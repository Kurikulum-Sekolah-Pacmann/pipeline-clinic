import pandas as pd
from datetime import datetime


from src.warehouse.load.handle_error import handle_error
from src.utils.helper import extract_target
from src.utils.log import etl_log

def transform_fact_salary(data, table_name: str) -> pd.DataFrame:
    """
    This function is used to transform the data from the staging area before loading it into the warehouse area.
    """
    try:
        process = "transformation"

        # rename column 
        data = data.rename(columns={'salary_id':'salary_nk','employee_id': 'employee_nk', 'payment_date':'payment_date_nk'})

        #get parent table  
        employee = extract_target('dim_employee')
        date = extract_target('dim_date')

        # lookup foreign key
        data['employee_id'] = data['employee_nk'].apply(lambda x: employee.loc[employee['employee_nk'] == x, 'employee_id'].values[0] if len(employee.loc[employee['employee_nk'] == x, 'employee_id'].values) > 0 else None)
        data['payment_date'] = data['payment_date_nk'].apply(lambda x: date.loc[date['date_actual'] == x, 'date_id'].values[0] if len(date.loc[date['date_actual'] == x, 'date_id'].values) > 0 else None)  

        # drop unnecessary columns
        data = data.drop(columns=['employee_nk', 'payment_date_nk','created_at'])

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