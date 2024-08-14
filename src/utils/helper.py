from sqlalchemy import create_engine
from dotenv import load_dotenv
import os
from oauth2client.service_account import ServiceAccountCredentials
import gspread
import pandas as pd
import sentry_sdk
import requests
from datetime import timedelta

load_dotenv(".env")

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PORT = os.getenv("DB_PORT")
DB_PASS = os.getenv("DB_PASS")

DB_NAME_CLINIC = os.getenv("DB_NAME_CLINIC")
DB_NAME_CLINIC_OPS = os.getenv("DB_NAME_CLINIC_OPS")
DB_NAME_STG = os.getenv("DB_NAME_STG")
DB_NAME_LOG = os.getenv("DB_NAME_LOG")
DB_NAME_WH = os.getenv("DB_NAME_WH")

CRED_PATH = os.getenv("CRED_PATH")
KEY_SPREASHEET = os.getenv("KEY_SPREASHEET")

ACCESS_KEY_MINIO = os.getenv("ACCESS_KEY_MINIO")
SECRET_KEY_MINIO = os.getenv("SECRET_KEY_MINIO")

def clinic_engine():
    return create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME_CLINIC}")

def clinic_ops_engine():
    return create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME_CLINIC_OPS}")

def stg_engine():
    return create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME_STG}")

def log_engine():
    return create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME_LOG}")

def wh_engine():
    return create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME_WH}")

def read_sql(PATH, table_name):
    #open your file .sql
    with open(f"{PATH}{table_name}.sql", 'r') as file:
        content = file.read()
    
    #return query text
    return content

def extract_target(table_name: str):
    """
    this function is used to extract data from the data warehouse.
    """
    conn = wh_engine()

    # Constructs a SQL query to select all columns from the specified table_name where created_at is greater than etl_date.
    query = f"SELECT * FROM {table_name}"

    # Execute the query with pd.read_sql
    df = pd.read_sql(sql=query, con=conn)
    
    return df