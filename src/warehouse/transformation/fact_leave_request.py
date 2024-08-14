import pandas as pd
from datetime import datetime


from src.warehouse.load.handle_error import handle_error
from src.utils.helper import extract_target
from src.utils.log import etl_log

def transform_fact_leave_request(data, table_name: str) -> pd.DataFrame:
    """
    This function is used to transform the data from the staging area before loading it into the warehouse area.
    """
    try:
        process = "transformation"

        # rename column 
        data = data.rename(columns={'leave_id':'leave_request_nk','employee_id': 'employee_nk', 'start_date':'start_date_nk', 'end_date':'end_date_nk'})    

        # rename value leave type 'Casual' to 'Annual'
        data['leave_type'] = data['leave_type'].apply(lambda x: 'Annual' if x == 'Casual' else x)
        
        #get parent table  
        employee = extract_target('dim_employee')
        date = extract_target('dim_date')

        # lookup foreign key
        data['employee_id'] = data['employee_nk'].apply(lambda x: employee.loc[employee['employee_nk'] == x, 'employee_id'].values[0] if len(employee.loc[employee['employee_nk'] == x, 'employee_id'].values) > 0 else None)
        data['start_date'] = data['start_date_nk'].apply(lambda x: date.loc[date['date_actual'] == x, 'date_id'].values[0] if len(date.loc[date['date_actual'] == x, 'date_id'].values) > 0 else None)
        data['end_date'] = data['end_date_nk'].apply(lambda x: date.loc[date['date_actual'] == x, 'date_id'].values[0] if len(date.loc[date['date_actual'] == x, 'date_id'].values) > 0 else None)


        # drop unnecessary columns
        data = data.drop(columns=['employee_nk', 'start_date_nk', 'end_date_nk','created_at'])

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