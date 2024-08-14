import pandas as pd
from datetime import datetime


from src.warehouse.load.handle_error import handle_error
from src.utils.helper import extract_target
from src.utils.log import etl_log

# param: data_employee, data_speciality, data_role, table_name
def transform_employee(data_employee: pd.DataFrame, data_speciality: pd.DataFrame, data_role: pd.DataFrame, table_name: str) -> pd.DataFrame:
    """
    This function is used to transform the data from the staging area before loading it into the warehouse area.
    """
    try:
        process = "transformation"

        # rename column 
        data_employee = data_employee.rename(columns={'employee_id':'employee_nk'})
        
        # deduplication based on customer_nk
        data_employee = data_employee.drop_duplicates(subset='employee_nk')

        # drop unnecessary columns
        data_employee = data_employee.drop(columns=['created_at'])
        data_speciality = data_speciality.drop(columns=['created_at'])
        data_role = data_role.drop(columns=['created_at','description'])  

        # rename_column
        data_speciality = data_speciality.rename(columns={'name':'speciality_name'})
        data_role = data_role.rename(columns={'name':'role_name'})

        #join data employee, speciality, role
        data = pd.merge(data_employee, data_speciality, on='speciality_id', how='left')
        data = pd.merge(data, data_role, on='role_id', how='left')

        # drop unnecessary columns
        data = data.drop(columns=['speciality_id', 'role_id'])

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