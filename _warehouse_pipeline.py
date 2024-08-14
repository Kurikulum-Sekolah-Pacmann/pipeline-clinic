from src.warehouse.extract.extract_database import extract_staging
from src.warehouse.load.load import load_warehouse

from src.warehouse.transformation.speciality import transform_speciality
from src.warehouse.transformation.doctor import transform_doctor
from src.warehouse.transformation.patient import transform_patient
from src.warehouse.transformation.medication import transform_medication
from src.warehouse.transformation.fact_appointment import transform_fact_appointment
from src.warehouse.transformation.employee import transform_employee
from src.warehouse.transformation.fact_salary import transform_fact_salary
from src.warehouse.transformation.fact_leave_request import transform_fact_leave_request
from src.warehouse.transformation.equipment import transform_equipment
from src.warehouse.transformation.fact_maintenance_request import transform_fact_maintenance_request
from src.warehouse.transformation.fact_maintenance_record import transform_fact_maintenance_record
from src.warehouse.validation.validation import report_validation_doctor, report_validation_patient, report_validation_employee, report_validation_leave_requests, report_validation_equipment

def pipeline_warehouse():
    print("==== Start Warehouse Pipeline ===")

    # Extract data from staging
    df_doctor = extract_staging(table_name='doctor')
    df_patient = extract_staging(table_name='patient')
    df_speciality = extract_staging(table_name='speciality')
    df_medication = extract_staging(table_name='medication')
    df_appointment = extract_staging(table_name='appointment')
    df_prescription = extract_staging(table_name='prescription')
    df_employee = extract_staging(table_name='employee')
    df_role = extract_staging(table_name='role')
    df_salary = extract_staging(table_name='salary')
    df_leave_requests = extract_staging(table_name='leave_requests')
    df_equipment = extract_staging(table_name='equipment')
    df_maintenance_record = extract_staging(table_name='maintenance_record')
    df_maintenance_request = extract_staging(table_name='maintenance_request')
    df_speciality_ops = extract_staging(table_name='speciality_ops')

    # Transform and Load Data
    # Table Dimension
    speciality_transformed = transform_speciality(df_speciality, table_name='dim_speciality')
    load_warehouse(data=speciality_transformed, table_name='dim_speciality', 
               schema='public', idx_name='speciality_nk', table_process='speciality', source='staging')
    
    doctor_transformed = transform_doctor(df_doctor, table_name='dim_doctor')
    report_validation_doctor(doctor_transformed)
    load_warehouse(data=doctor_transformed, table_name='dim_doctor', 
                schema='public', idx_name='doctor_nk', table_process='doctor', source='staging')
    
    patient_transformed = transform_patient(df_patient, table_name='dim_patient')
    report_validation_patient(patient_transformed)
    load_warehouse(data=patient_transformed, table_name='dim_patient', 
               schema='public', idx_name='patient_nk', table_process='patient', source='staging')
    
    medication_transformed = transform_medication(df_medication, table_name='dim_medication')
    load_warehouse(data=medication_transformed, table_name='dim_medication', 
               schema='public', idx_name='medication_nk', table_process='medication', source='staging')
    
    employee_transformed = transform_employee(df_employee, df_speciality_ops, df_role, table_name='dim_employee')
    report_validation_employee(employee_transformed)
    load_warehouse(data=employee_transformed, table_name='dim_employee', 
               schema='public', idx_name='employee_nk', table_process='employee', source='staging')
    
    equipment_transformed = transform_equipment(df_equipment, table_name='dim_equipment')
    report_validation_equipment(equipment_transformed)
    load_warehouse(data=equipment_transformed, table_name='dim_equipment', 
               schema='public', idx_name='equipment_nk', table_process='equipment', source='staging')
    
    # if df_appointment is not empty then transform into fact_appointment
    #Table Fact
    if not df_appointment.empty:
        fact_appointment_transformed = transform_fact_appointment(df_appointment, df_prescription, table_name='fact_appointment')
        load_warehouse(data=fact_appointment_transformed, table_name='fact_appointment', 
               schema='public', idx_name=['appointment_nk','prescription_nk'], table_process='appointment', source='staging')
    
    salary_transformed = transform_fact_salary(df_salary, table_name='fact_salary')
    load_warehouse(data=salary_transformed, table_name='fact_salary', 
               schema='public', idx_name='salary_nk', table_process='salary', source='staging')
    
    leave_requests_transformed = transform_fact_leave_request(df_leave_requests, table_name='fact_leave_requests')
    report_validation_leave_requests(leave_requests_transformed)
    load_warehouse(data=leave_requests_transformed, table_name='fact_leave_requests', 
               schema='public', idx_name='leave_request_nk', table_process='leave_requests', source='staging')
    
    maintenance_request_transformed = transform_fact_maintenance_request(df_maintenance_request, table_name='fact_maintenance_request')
    load_warehouse(data=maintenance_request_transformed, table_name='fact_maintenance_request', 
               schema='public', idx_name='maintenance_request_nk', table_process='maintenance_request', source='staging')
    
    maintenance_report_transformed = transform_fact_maintenance_record(df_maintenance_record, table_name='fact_maintenance_record')
    load_warehouse(data=maintenance_report_transformed, table_name='fact_maintenance_record', 
               schema='public', idx_name='maintenance_record_nk', table_process='maintenance_record', source='staging')
    
    print("==== End Warehouse Pipeline ===")