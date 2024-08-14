from sqlalchemy import create_engine
import pandas as pd
from dotenv import load_dotenv
import os
import csv
from datetime import datetime
from src.utils.helper import clinic_engine, clinic_ops_engine, stg_engine, log_engine, wh_engine

def extract_list_table(db_name):
    try:
        # create connection to database
        if db_name == 'clinic':
            conn =  clinic_engine()
        elif db_name == 'clinic_ops':
            conn = clinic_ops_engine()

        # Get list of tables in the database
        query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
        df = pd.read_sql(sql=query, con=conn)
        return df
    except Exception as e:
        print(e)
        return None

def extract_database(db_name, table_name: str): 
    try:
        # create connection to database
        if db_name == 'clinic':
            conn =  clinic_engine()
        elif db_name == 'clinic_ops':
            conn = clinic_ops_engine()

        # Constructs a SQL query to select all columns from the specified table_name
        query = f"SELECT * FROM {table_name}"

        # Execute the query with pd.read_sql
        df = pd.read_sql(sql=query, con=conn)
        return df
    except Exception as e:
        print(e)
        return None

    
