# Live Class Week 6

## Description
1. `Problem` <br>
In the clinic's data infrastructure, there are multiple data sources that need to be integrated and cleaned. Specifically, data is coming from various systems including spreadsheet maintenance request records, the Clinic database, and the Clinic Ops database. 
    - Spreadsheet maintenance request data: Contains request for maintenance clinic's equipment
    - the Clinic Database: Contains data appointment and prescription patient
    - Clinic Ops databases: Contains operasional data, like employee salary, leave request, equipment, etc

2. `Solution` <br>
To address these issues, an ETL (Extract, Transform, Load) pipeline will be developed. This pipeline will extract data from the different sources, apply necessary transformations to clean and standardize the data, and then load it into a unified data warehouse. 
The pipeline will have 2 Layers, Staging and Warehouse, have Log system and Validation system <br>




## Preparation
`Source Dataset`: 
1. Duplicate maintenance_request data: [Link](https://docs.google.com/spreadsheets/d/1hahMgeJw_ki35tANErRzbxzFMJJKV3aetIboL4_vJ-o/edit?usp=sharing)
2. Restore Database Clinic: [Link](https://drive.google.com/file/d/1ClXTIIKaELOei7TB9eGBY0Y7hHY-_2It/view?usp=sharing)
3. Restore Database Clinic Ops: [Link](https://drive.google.com/file/d/1UlMTbWRLHtuss4huR4icnJDWlijPjdw1/view?usp=sharing)

`Target Storage`
1. Staging: [Link](https://drive.google.com/file/d/1KxLDIaYSHf8inbZ2fLN0sDeckSfemaXv/view?usp=sharing)
2. Warehouse: [Link](https://drive.google.com/file/d/18ShJnBZwIKO3CGFXlANa9xmnIB-lhrAb/view?usp=sharing)
3. Log:[Link](https://drive.google.com/file/d/1uSXglsJLVupIfIKnm2_6H31s7x5w5AYB/view?usp=sharing)

`Tools and Technologies`:
- Python: For build Data Pipeline
- PostgreSQL: For log, staging and final data storage.
- MinIO: For load failed data, load vaidation and profiling report.
- Docker: For running MinIO



## Project 
   1. Clone Repo: https://github.com/Kurikulum-Sekolah-Pacmann/pipeline-clinic.git 
   2. Save Your Credential Google Service Account
   3. Prepare Your MiniO (Access Key, Secreet Key, Bucket Name: "error-dellstore")
   4. create your .env

      ```
        DB_HOST="YOUR HOST"
        DB_USER="USERNAME"
        DB_PASS="PASS"
        DB_PORT="PORT"
        DB_NAME_CLINIC="clinic"
        DB_NAME_CLINIC_OPS="clinic_ops"
        DB_NAME_STG="staging_clinic"
        DB_NAME_LOG="etl_log"
        DB_NAME_WH="warehouse_clinic"
        CRED_PATH='your_path/creds/creds.json'
        KEY_SPREADSHEET='YOUR KEY SPREADSHEET'
        ACCESS_KEY_MINIO = 'ACCESS KEY MINIO'
        SECRET_KEY_MINIO = 'SECRET KEY MINIO'
        MODEL_PATH_LOG_ETL='your_path/src/utils/model/'

      ```
