import pandas as pd
from datetime import datetime


from src.warehouse.load.handle_error import handle_error
from src.utils.helper import extract_target
from src.utils.log import etl_log

def transform_fact_appointment(data_appointment: pd.DataFrame, data_prescription, table_name: str) -> pd.DataFrame:
    """
    This function is used to transform the data from the staging area before loading it into the warehouse area.
    """
    try:
        process = "transformation"

        # rename column 
        data_appointment = data_appointment.rename(columns={'appointment_id':'appointment_nk','doctor_id': 'doctor_nk', 'patient_id': 'patient_nk','appointment_date':'appointment_date_nk'})
        data_prescription = data_prescription.rename(columns={'prescription_id':'prescription_nk','medication_id': 'medication_nk', 'appointment_id': 'appointment_nk'})
        
        # drop unnecessary columns
        data_appointment = data_appointment.drop(columns=['created_at'])
        data_prescription = data_prescription.drop(columns=['created_at'])

        #join data
        data = pd.merge(data_appointment, data_prescription, on='appointment_nk', how='inner')


        #get parent table  
        patients = extract_target('dim_patient')
        doctor = extract_target('dim_doctor')
        medication = extract_target('dim_medication')
        date = extract_target('dim_date')
        time = extract_target('dim_time')

        # lookup foreign key
        data['patient_id'] = data['patient_nk'].apply(lambda x: patients.loc[patients['patient_nk'] == x, 'patient_id'].values[0] if len(patients.loc[patients['patient_nk'] == x, 'patient_id'].values) > 0 else None)
        data['doctor_id'] = data['doctor_nk'].apply(lambda x: doctor.loc[doctor['doctor_nk'] == x, 'doctor_id'].values[0] if len(doctor.loc[doctor['doctor_nk'] == x, 'doctor_id'].values) > 0 else None)
        data['medication_id'] = data['medication_nk'].apply(lambda x: medication.loc[medication['medication_nk'] == x, 'medication_id'].values[0] if len(medication.loc[medication['medication_nk'] == x, 'medication_id'].values) > 0 else None)
        
        # split date and time from appointment_date_nk, for time round to minutes
        data['appointment_date_nk'] = pd.to_datetime(data['appointment_date_nk'])
        data['appointment_time_nk'] = data['appointment_date_nk'].dt.round('min').dt.time
        data['appointment_date_nk'] = data['appointment_date_nk'].dt.date

        # lookup foreign key
        data['appointment_date'] = data['appointment_date_nk'].apply(lambda x: date.loc[date['date_actual'] == x, 'date_id'].values[0] if len(date.loc[date['date_actual'] == x, 'date_id'].values) > 0 else None)
        data['appointment_time'] = data['appointment_time_nk'].apply(lambda x: time.loc[time['time_actual'] == x, 'time_id'].values[0] if len(time.loc[time['time_actual'] == x, 'time_id'].values) > 0 else None)

        # drop unnecessary columns
        data = data.drop(columns=['patient_nk', 'doctor_nk', 'medication_nk', 'appointment_date_nk', 'appointment_time_nk'])

        log_msg = {
                "step" : "warehouse",
                "process": process,
                "status": "success",
                "source": "staging",
                "table_name": table_name,
                "etl_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # Current timestamp
                }
        
        return data
    except Exception as e:
        print(e)
        log_msg = {
            "step" : "warehouse",
            "process": process,
            "status": "failed",
            "source": "staging",
            "table_name": table_name,
            "etl_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),  # Current timestamp,
            "error_msg": str(e)
            }
        
         # Handling error: save data to Object Storage
        try:
            handle_error(data = data, table_name= table_name, process=process)
        except Exception as e:
            print(e)
    finally:
        # Save the log message
        etl_log(log_msg)