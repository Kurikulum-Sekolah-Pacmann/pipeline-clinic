from oauth2client.service_account import ServiceAccountCredentials
import gspread
import pandas as pd
from dotenv import load_dotenv
import os
import csv
from datetime import datetime

load_dotenv(".env")

CRED_PATH = os.getenv("CRED_PATH")
KEY_SPREADSHEET = os.getenv("KEY_SPREADSHEET")

def auth_gspread():
    scope = ['https://spreadsheets.google.com/feeds',
             'https://www.googleapis.com/auth/drive']

    #Define your credentials
    credentials = ServiceAccountCredentials.from_json_keyfile_name(CRED_PATH, scope) # Your json file here

    gc = gspread.authorize(credentials)

    return gc

def init_key_file():
    #define credentials to open the file
    gc = auth_gspread()
    
    #open spreadsheet file by key
    sheet_result = gc.open_by_key(KEY_SPREADSHEET)
    
    return sheet_result

def extract_sheet(worksheet_name: str) -> pd.DataFrame:
    # init sheet
    sheet_result = init_key_file()
    
    worksheet_result = sheet_result.worksheet(worksheet_name)
    
    df_result = pd.DataFrame(worksheet_result.get_all_values())
    
    # set first rows as columns
    df_result.columns = df_result.iloc[0]
    
    # get all the rest of the values
    df_result = df_result[1:].copy()
    
    return df_result
