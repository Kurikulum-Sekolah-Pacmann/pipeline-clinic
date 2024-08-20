# Source to Target Mapping

Source: Staging
Target: Warehouse



| Source Table: `speciality`                  | Target Table: `dim_speciality`       | **Description**                              |
|---------------------------------------------|--------------------------------------|----------------------------------------------|
| `speciality_id` (serial4)                   | `speciality_nk` (serial4)            | Direct Mapping                               |
| `name` (varchar(255))                       | `name` (varchar(255))                | Direct Mapping                               |


| Source Table: `doctor`                      | Target Table: `dim_doctor`           | **Description**                              |
|---------------------------------------------|--------------------------------------|----------------------------------------------|
| `doctor_id` (serial4)                       | `doctor_nk` (int4)                   | Direct Mapping                               |
| `name` (varchar(255))                       | `name` (varchar(255))                | Direct Mapping                               |
| `phone_number` (varchar(20))                | `phone_number` (varchar(20))         | Direct Mapping                               |
| `speciality_id` (int4)                      | `speciality_id` (uuid)               | Lookup to `dim_speciality`                   |




| Source Table: `medication`                  | Target Table: `dim_medication`       | **Description**                              |
|---------------------------------------------|--------------------------------------|----------------------------------------------|
| `medication_id` (serial4)                   | `medication_nk` (int4)               | Direct Mapping                               |
| `name` (varchar(255))                       | `name` (varchar(255))                | Direct Mapping                               |
| `manufacturer` (varchar(255))               | `manufacturer` (varchar(255))        | Direct Mapping                               |
| `dosage_form` (varchar(50))                 | `dosage_form` (varchar(50))          | Direct Mapping                               |
| `strength` (varchar(50))                    | `strength` (varchar(50))             | Direct Mapping                               |
| `description` (text)                        | `description` (text)                 | Direct Mapping                               |


| Source Table: `patient`                      | Target Table: `dim_patient`       | **Description**                                  |
|----------------------------------------------|-----------------------------------|--------------------------------------------------|
| `patient_id` (serial4)                       | `patient_nk` (int4)               | Direct Mapping                                   |
| `name` (varchar(255))                        | `name` (varchar(255))             | Direct Mapping                                   |
| `dob` (date)                                 | `dob` (date)                      | Direct Mapping                                   |
| `gender` (varchar)                           | `gender` (varchar)                | Direct Mapping                                   |
| `phone_number` (varchar)                     | `phone_number` (varchar)          | Direct Mapping                                   |
| `address` (varchar(255))                     | `address` (varchar(255))          | Direct Mapping                                   |
| `state_code` (varchar(5))                    | `state_code` (varchar(5))         | Direct Mapping                                   |



| Source Tables: `appointment`, `prescription` | Target Table: `fact_appointment`   | **Description**                                      |
|----------------------------------------------|------------------------------------|------------------------------------------------------|
| `appointment_id` (serial4)                   | `appointment_nk` (int4)            | Direct Mapping                                       |
| `patient_id` (int4)                          | `patient_id` (uuid)                | Lookup to `dim_patient`                              |
| `doctor_id` (int4)                           | `doctor_id` (uuid)                 | Lookup to `dim_doctor`                               |
| `appointment_date` (timestamp)               | `appointment_date` (int4)          | Convert Date Part Lookup to `dim_date`               |
| `notes` (text)                               | `notes` (text)                     | Direct Mapping                                       |
| `status` (varchar(20))                       | `status` (varchar(20))             | Direct Mapping                                       |
| `created_at` (timestamptz)                   | `created_at` (timestamptz)         | Direct Mapping                                       |
| `appointment_date` (timestamp)               | `appointment_time` (int4)          | Convert Time Part Lookup to `dim_time`               |
| `prescription_id` (serial4)                  | `prescription_nk` (int4)           | Direct Mapping                                       |
| `medication_id` (int4)                       | `medication_id` (uuid)             | Lookup to `dim_medication`                           |



| Source Table: `employee`                    | Target Table: `dim_employee`      | **Description**                                       |
|---------------------------------------------|-----------------------------------|-------------------------------------------------------|
| `employee_id` (serial4)                     | `employee_nk` (serial4)           | Direct Mapping                                        |
| `name` (varchar(255))                       | `name` (varchar(255))             | Direct Mapping                                        |
| `phone_number` (varchar)                    | `phone_number` (varchar)          | Direct Mapping                                        |
| `speciality_id` (int4)                      | `speciality_name` (varchar)       | Lookup to `dim_speciality`, get `speciality_name`     |
| `role_id` (int4)                            | `role_name` (varchar)             | Lookup to `dim_role` get `role_name`                  |


| Source Table: `salary`                    | Target Table: `fact_salary`       | **Description**                                               |
|-------------------------------------------|-----------------------------------|---------------------------------------------------------------|
| `salary_id` (serial4)                     | `salary_nk` (int4)                | Direct Mapping                                                |
| `employee_id` (int4)                      | `employee_id` (uuid)              | Lookup to `dim_employee`                                      |
| `amount` (numeric)                        | `amount` (numeric)                | Direct Mapping                                                |
| `payment_date` (date)                     | `payment_date` (int4)             | Convert Date Lookup to `dim_date`                             |



| Source Table: `leave_requests`             | Target Table: `fact_leave_requests` | **Description**                                               |
|---------------------------------------------|-------------------------------------|---------------------------------------------------------------|
| `leave_id` (serial4)                       | `leave_request_nk` (int4)           | Direct Mapping                                                |
| `employee_id` (int4)                       | `employee_id` (uuid)                | Lookup to `dim_employee`                                      |
| `leave_type` (varchar)                     | `leave_type` (varchar(50))          | Direct Mapping                                                |
| `start_date` (date)                        | `start_date` (int4)                 | Convert Date Lookup to `dim_date`                             |
| `end_date` (date)                          | `end_date` (int4)                   | Convert Date Lookup to `dim_date`                             |
| `status` (varchar)                         | `status` (varchar(20))              | Direct Mapping                                                |



| Source Table: `equipment`                  | Target Table: `dim_equipment`        | **Description**                                             |
|---------------------------------------------|--------------------------------------|-------------------------------------------------------------|
| `equipment_id` (serial4)                    | `equipment_nk` (int)                | Direct Mapping                                              |
| `name` (varchar)                           | `name` (varchar(255))                | Direct Mapping                                              |
| `serial_number` (varchar)                  | `serial_number` (varchar(100))       | Direct Mapping                                              |
| `purchase_date` (date)                     | `purchase_date` (date)               | Direct Mapping                                              |
| `warranty_expiration` (date)                | `warranty_expiration` (date)          | Direct Mapping                                              |
| `location` (varchar)                       | `location` (varchar(255))            | Direct Mapping                                              |



| Source Table: `maintenance_record`           | Target Table: `fact_maintenance_record` | **Description**                                              |
|-----------------------------------------------|-----------------------------------------|--------------------------------------------------------------|
| `record_id` (serial4)                         | `maintenance_record_nk` (int)          | Direct Mapping                                               |
| `equipment_id` (int4)                         | `equipment_id` (uuid)                   | Lookup to `dim_equipment`                                   |
| `maintenance_date` (date)                     | `maintenance_date` (int4)               | Convert Date to `dim_date`                                  |
| `description` (text)                         | `description` (text)                    | Direct Mapping                                              |
| `cost` (varchar)                             | `cost` (varchar)                        | Direct Mapping                                              |



| Source Table: `maintenance_request`           | Target Table: `fact_maintenance_request` | **Description**                                              |
|-----------------------------------------------|------------------------------------------|--------------------------------------------------------------|
| `id` (serial4)                                | `maintenance_request_nk` (uuid)          | Direct Mapping                                               |
| `name` (varchar)                             | `name` (varchar)                         | Direct Mapping                                              |
| `serial_number` (varchar)                     | `serial_number` (varchar)                | Direct Mapping                                              |
| `request_date` (date)                         | `request_date` (int4)                    | Convert Date to `dim_date`                                 |
| `location` (varchar)                         | `location` (varchar)                     | Direct Mapping                                              |
| `request_note` (text)                         | `request_note` (text)                    | Direct Mapping                                              |