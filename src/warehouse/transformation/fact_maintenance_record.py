import pandas as pd
from datetime import datetime


from src.warehouse.load.handle_error import handle_error
from src.utils.helper import extract_target
from src.utils.log import etl_log

def transform_fact_maintenance_record(data, table_name: str) -> pd.DataFrame:
    """
    This function is used to transform the data from the staging area before loading it into the warehouse area.
    """
    try:
        process = "transformation"
        # rename column
        data = data.rename(columns={'record_id':'maintenance_record_nk','maintenance_date':'maintenance_date_nk', 'equipment_id':'equipment_nk'})  

        #get parent table  
        equipment = extract_target('dim_equipment')
        date = extract_target('dim_date')
        
        # column cost remove 'USD' and convert to float
        data['cost'] = data['cost'].apply(lambda x: float(x.replace('USD','').replace(',','')))
        
        # lookup foreign key
        data['equipment_id'] = data['equipment_nk'].apply(lambda x: equipment.loc[equipment['equipment_nk'] == x, 'equipment_id'].values[0] if len(equipment.loc[equipment['equipment_nk'] == x, 'equipment_id'].values) > 0 else None)
        data['maintenance_date'] = data['maintenance_date_nk'].apply(lambda x: date.loc[date['date_actual'] == x, 'date_id'].values[0] if len(date.loc[date['date_actual'] == x, 'date_id'].values) > 0 else None)

        # drop unnecessary columns
        data = data.drop(columns=['equipment_nk','maintenance_date_nk','created_at'])

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