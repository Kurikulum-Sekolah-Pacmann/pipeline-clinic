import re
import pandas as pd
import datetime
from minio import Minio
from io import BytesIO
from dotenv import load_dotenv
import os
import json

load_dotenv(".env", override=True)

ACCESS_KEY_MINIO = os.getenv("ACCESS_KEY_MINIO")
SECRET_KEY_MINIO = os.getenv("SECRET_KEY_MINIO")
bucket_name = "validation-clinic"

def save_report(data, table_name):

    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    # Initialize MinIO client
    client = Minio('localhost:9000',
                access_key=ACCESS_KEY_MINIO,
                secret_key=SECRET_KEY_MINIO,
                secure=False)

    # Make a bucket if it doesn't exist
    if not client.bucket_exists(bucket_name):
        client.make_bucket(bucket_name)

    # Convert dict to JSON and then to bytes
    json_report = json.dumps(data)
    json_bytes = json_report.encode('utf-8')

    # Upload the CSV file to the bucket
    client.put_object(
        bucket_name=bucket_name,
        object_name=f"{table_name}_{current_date}.json", #name the fail source name and current etl date
        data=BytesIO(json_bytes),
        length=len(json_bytes),
        content_type='application/csv'
    )
    print(f"Save validation report as {table_name}_{current_date}.json")

# Validation
# for: doctor, patient and employee
# num_invalid_phone
# list_people_invalid_phone
# May start with a + sign (optional).
# May include a 1 after the + (optional).
# Contains between 9 and 15 digits.
# Has no additional characters before or after the digits.

def check_invalid_phone(df, report):
    for col in df.columns:
        if col == "phone_number":
            report["report"][col] = {}
            report["report"][col]["num_invalid_phone"] = 0
            report["report"][col]["list_people_invalid_phone"] = []
            for idx, phone in enumerate(df[col]):
                if not re.match(r"^\+?1?\d{9,15}$", str(phone).replace(" ", "")):
                    report["report"][col]["num_invalid_phone"] += 1
                    report["report"][col]["list_people_invalid_phone"].append(idx)
    return report

# for: doctor and employee
# num_missing_speciality
# list_doctor_missing_speciality
def check_missing_speciality(df, report):
    for col in df.columns:
        if col == "speciality_id":
            report["report"][col] = {}
            report["report"][col]["num_missing_speciality"] = 0
            report["report"][col]["list_doctor_missing_speciality"] = []
            for idx, speciality in enumerate(df[col]):
                if speciality == None:
                    report["report"][col]["num_missing_speciality"] += 1
                    report["report"][col]["list_doctor_missing_speciality"].append(idx)
    return report

# for: fact_leave_requests
# invalid is not Parental, Sick, Religous, Annual not case sensitiv
# num_leave_type_invalid
# list_leave_type_invalid
def check_leave_type(df, report):
    for col in df.columns:
        if col == "leave_type":
            report["report"][col] = {}
            report["report"][col]["num_leave_type_invalid"] = 0
            report["report"][col]["list_leave_type_invalid"] = []
            for idx, leave_type in enumerate(df[col]):
                if leave_type.lower() not in ["parental", "sick", "religous", "annual"]:
                    report["report"][col]["num_leave_type_invalid"] += 1
                    report["report"][col]["list_leave_type_invalid"].append(idx)
    return report


# for: equipment
# num_equipment_old (more than 8 years), check column purchase_date
# list_equipment_old

def check_equipment_old(df, report):
    for col in df.columns:
        if col == "purchase_date":
            report["report"]["purchase_date"] = {}
            report["report"]["purchase_date"]["num_equipment_old"] = 0
            report["report"]["purchase_date"]["list_equipment_old"] = []
            for idx, purchase_date in enumerate(df["purchase_date"]):
                if (datetime.datetime.now() - datetime.datetime.combine(purchase_date, datetime.datetime.min.time())).days > 2920:
                    report["report"]["purchase_date"]["num_equipment_old"] += 1
                    report["report"]["purchase_date"]["list_equipment_old"].append(idx)
    return report

# for: doctor
def report_validation_doctor(df):
    data = {
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d"),
        "table_name": "doctor",
        "report":{}
    }
    data.update(check_invalid_phone(df=df, report=data))
    data.update(check_missing_speciality(df=df, report=data))

    save_report(data, "doctor")

# for: patient
def report_validation_patient(df):
    data = {
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d"),
        "table_name": "patient",
        "report":{}
    }
    data.update(check_invalid_phone(df=df, report=data))

    save_report(data, "patient")

# for: employee
def report_validation_employee(df):
    data = {
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d"),
        "table_name": "employee",
        "report":{}
    }
    data.update(check_invalid_phone(df=df, report=data))

    save_report(data, "employee")

# for: fact_leave_requests
def report_validation_leave_requests(df):
    data = {
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d"),
        "table_name": "fact_leave_requests",
        "report":{}
    }
    data.update(check_leave_type(df=df, report=data))

    save_report(data, "fact_leave_requests")

# for: equipment
def report_validation_equipment(df):
    data = {
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d"),
        "table_name": "equipment",
        "report":{}
    }
    data.update(check_equipment_old(df=df, report=data))

    save_report(data, "equipment")
