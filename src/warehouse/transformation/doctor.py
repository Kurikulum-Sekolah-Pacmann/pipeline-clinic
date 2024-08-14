import pandas as pd
from datetime import datetime


from src.warehouse.load.handle_error import handle_error
from src.utils.helper import extract_target
from src.utils.log import etl_log

def transform_doctor(data: pd.DataFrame, table_name: str) -> pd.DataFrame:
    """
    This function is used to transform the data from the staging area before loading it into the warehouse area.
    """
    try:
        process = "transformation"

        # rename column doctor
        data = data.rename(columns={'doctor_id': 'doctor_nk', 'speciality_id': 'speciality_nk'})  
        
        # deduplication based on customer_nk
        data = data.drop_duplicates(subset='doctor_nk')


        #Lookup `speciality_id` from `dim_speciality` table based on `speciality_nk` 
        specialities = extract_target('dim_speciality')
        data['speciality_id'] = data['speciality_nk'].apply(lambda x: specialities.loc[specialities['speciality_nk'] == x, 'speciality_id'].values[0] if len(specialities.loc[specialities['speciality_nk'] == x, 'speciality_id'].values) > 0 else None)
        
        # drop unnecessary columns
        data = data.drop(columns=['speciality_nk', 'created_at'])

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