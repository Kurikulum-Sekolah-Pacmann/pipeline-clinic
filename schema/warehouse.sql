-- DROP SCHEMA public;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP SEQUENCE public.dim_employee_employee_nk_seq;

CREATE SEQUENCE public.dim_employee_employee_nk_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.dim_speciality_speciality_nk_seq;

CREATE SEQUENCE public.dim_speciality_speciality_nk_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.dim_date definition

-- Drop table

-- DROP TABLE dim_date;

CREATE TABLE dim_date (
	date_id int4 NOT NULL,
	date_actual date NOT NULL,
	day_suffix varchar(4) NOT NULL,
	day_name varchar(9) NOT NULL,
	day_of_year int4 NOT NULL,
	week_of_month int4 NOT NULL,
	week_of_year int4 NOT NULL,
	week_of_year_iso bpchar(10) NOT NULL,
	month_actual int4 NOT NULL,
	month_name varchar(9) NOT NULL,
	month_name_abbreviated bpchar(3) NOT NULL,
	quarter_actual int4 NOT NULL,
	quarter_name varchar(9) NOT NULL,
	year_actual int4 NOT NULL,
	first_day_of_week date NOT NULL,
	last_day_of_week date NOT NULL,
	first_day_of_month date NOT NULL,
	last_day_of_month date NOT NULL,
	first_day_of_quarter date NOT NULL,
	last_day_of_quarter date NOT NULL,
	first_day_of_year date NOT NULL,
	last_day_of_year date NOT NULL,
	mmyyyy bpchar(6) NOT NULL,
	mmddyyyy bpchar(10) NOT NULL,
	weekend_indr varchar(20) NOT NULL,
	CONSTRAINT dim_date_pkey PRIMARY KEY (date_id)
);


-- public.dim_employee definition

-- Drop table

-- DROP TABLE dim_employee;

CREATE TABLE dim_employee (
	employee_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	employee_nk serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	phone_number varchar NOT NULL,
	speciality_name varchar NULL,
	role_name varchar NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT dim_employee_pkey PRIMARY KEY (employee_id),
	CONSTRAINT uniq_emp UNIQUE (employee_nk)
);


-- public.dim_equipment definition

-- Drop table

-- DROP TABLE dim_equipment;

CREATE TABLE dim_equipment (
	equipment_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	equipment_nk int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	serial_number varchar(100) NOT NULL,
	purchase_date date NOT NULL,
	warranty_expiration date NULL,
	"location" varchar(255) NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT dim_equipment_equipment_nk_key UNIQUE (equipment_nk),
	CONSTRAINT dim_equipment_pkey PRIMARY KEY (equipment_id)
);


-- public.dim_medication definition

-- Drop table

-- DROP TABLE dim_medication;

CREATE TABLE dim_medication (
	medication_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	medication_nk int4 NULL,
	"name" varchar(255) NOT NULL,
	manufacturer varchar(255) NOT NULL,
	dosage_form varchar(50) NOT NULL,
	strength varchar(50) NOT NULL,
	description text NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT dim_medication_medication_nk_key UNIQUE (medication_nk),
	CONSTRAINT dim_medication_pkey PRIMARY KEY (medication_id)
);


-- public.dim_patient definition

-- Drop table

-- DROP TABLE dim_patient;

CREATE TABLE dim_patient (
	patient_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	patient_nk int4 NULL,
	"name" varchar(255) NULL,
	dob date NULL,
	gender varchar NULL,
	phone_number varchar NULL,
	address varchar(255) NULL,
	state_code varchar(5) NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT dim_patient_patient_nk_key UNIQUE (patient_nk),
	CONSTRAINT dim_patient_pkey PRIMARY KEY (patient_id)
);


-- public.dim_speciality definition

-- Drop table

-- DROP TABLE dim_speciality;

CREATE TABLE dim_speciality (
	speciality_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	speciality_nk serial4 NOT NULL,
	"name" varchar(255) NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT dim_speciality_name_key UNIQUE (name),
	CONSTRAINT dim_speciality_pkey PRIMARY KEY (speciality_id),
	CONSTRAINT dim_speciality_speciality_nk_key UNIQUE (speciality_nk)
);


-- public.dim_time definition

-- Drop table

-- DROP TABLE dim_time;

CREATE TABLE dim_time (
	time_id int4 NOT NULL,
	time_actual time NOT NULL,
	hours_24 bpchar(2) NOT NULL,
	hours_12 bpchar(2) NOT NULL,
	hour_minutes bpchar(2) NOT NULL,
	day_minutes int4 NOT NULL,
	day_time_name varchar(20) NOT NULL,
	day_night varchar(20) NOT NULL,
	CONSTRAINT time_pk PRIMARY KEY (time_id)
);


-- public.dim_doctor definition

-- Drop table

-- DROP TABLE dim_doctor;

CREATE TABLE dim_doctor (
	doctor_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	doctor_nk int4 NULL,
	"name" varchar(255) NULL,
	phone_number varchar(20) NULL,
	speciality_id uuid NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT dim_doctor_doctor_nk_key UNIQUE (doctor_nk),
	CONSTRAINT dim_doctor_pkey PRIMARY KEY (doctor_id),
	CONSTRAINT dim_doctor_speciality_id_fkey FOREIGN KEY (speciality_id) REFERENCES dim_speciality(speciality_id)
);


-- public.fact_appointment definition

-- Drop table

-- DROP TABLE fact_appointment;

CREATE TABLE fact_appointment (
	appointment_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	appointment_nk int4 NOT NULL,
	patient_id uuid NOT NULL,
	doctor_id uuid NOT NULL,
	medication_id uuid NOT NULL,
	appointment_date int4 NOT NULL,
	notes text NULL,
	status varchar(20) NULL DEFAULT NULL::character varying,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	appointment_time int4 NULL,
	prescription_nk int4 NULL,
	CONSTRAINT fact_appointment_pkey PRIMARY KEY (appointment_id),
	CONSTRAINT fact_appointment_un UNIQUE (appointment_nk, prescription_nk),
	CONSTRAINT am_fk_appointment_date FOREIGN KEY (appointment_date) REFERENCES dim_date(date_id),
	CONSTRAINT am_fk_medicine FOREIGN KEY (medication_id) REFERENCES dim_medication(medication_id),
	CONSTRAINT appointment_ibfk_1 FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
	CONSTRAINT appointment_ibfk_2 FOREIGN KEY (doctor_id) REFERENCES dim_doctor(doctor_id)
);


-- public.fact_leave_requests definition

-- Drop table

-- DROP TABLE fact_leave_requests;

CREATE TABLE fact_leave_requests (
	leave_request_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	leave_request_nk int4 NOT NULL,
	employee_id uuid NULL,
	leave_type varchar(50) NOT NULL,
	start_date int4 NOT NULL,
	end_date int4 NOT NULL,
	status varchar(20) NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fact_leave_requests_pkey PRIMARY KEY (leave_request_id),
	CONSTRAINT uniq_leave UNIQUE (leave_request_nk),
	CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES dim_employee(employee_id),
	CONSTRAINT leave_requests_end_fkey FOREIGN KEY (end_date) REFERENCES dim_date(date_id)
);


-- public.fact_maintenance_record definition

-- Drop table

-- DROP TABLE fact_maintenance_record;

CREATE TABLE fact_maintenance_record (
	maintenance_record_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	maintenance_record_nk int4 NOT NULL,
	equipment_id uuid NULL,
	maintenance_date int4 NOT NULL,
	description text NOT NULL,
	"cost" varchar NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fact_maintenance_record_maintenance_record_nk_key UNIQUE (maintenance_record_nk),
	CONSTRAINT fact_maintenance_record_pkey PRIMARY KEY (maintenance_record_id),
	CONSTRAINT maintenance_record_date_fkey FOREIGN KEY (maintenance_date) REFERENCES dim_date(date_id),
	CONSTRAINT maintenance_record_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES dim_equipment(equipment_id)
);


-- public.fact_maintenance_request definition

-- Drop table

-- DROP TABLE fact_maintenance_request;

CREATE TABLE fact_maintenance_request (
	maintenance_request_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	maintenance_request_nk int4 NOT NULL,
	equipment_id uuid NULL,
	request_date int4 NULL,
	"location" varchar(100) NULL,
	request_note text NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fact_maintenance_request_maintenance_request_nk_key UNIQUE (maintenance_request_nk),
	CONSTRAINT fact_maintenance_request_pkey PRIMARY KEY (maintenance_request_id),
	CONSTRAINT maintenance_req_date_fkey FOREIGN KEY (request_date) REFERENCES dim_date(date_id),
	CONSTRAINT maintenance_req_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES dim_equipment(equipment_id)
);


-- public.fact_salary definition

-- Drop table

-- DROP TABLE fact_salary;

CREATE TABLE fact_salary (
	salary_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	salary_nk int4 NOT NULL,
	employee_id uuid NULL,
	amount numeric NOT NULL,
	payment_date int4 NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fact_salary_pkey PRIMARY KEY (salary_id),
	CONSTRAINT uniq_salary UNIQUE (salary_nk),
	CONSTRAINT salary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES dim_employee(employee_id),
	CONSTRAINT salary_pay_date_fkey FOREIGN KEY (payment_date) REFERENCES dim_date(date_id)
);



-- DROP FUNCTION public.uuid_generate_v1();

CREATE OR REPLACE FUNCTION public.uuid_generate_v1()
 RETURNS uuid
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v1$function$
;

-- DROP FUNCTION public.uuid_generate_v1mc();

CREATE OR REPLACE FUNCTION public.uuid_generate_v1mc()
 RETURNS uuid
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v1mc$function$
;

-- DROP FUNCTION public.uuid_generate_v3(uuid, text);

CREATE OR REPLACE FUNCTION public.uuid_generate_v3(namespace uuid, name text)
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v3$function$
;

-- DROP FUNCTION public.uuid_generate_v4();

CREATE OR REPLACE FUNCTION public.uuid_generate_v4()
 RETURNS uuid
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v4$function$
;

-- DROP FUNCTION public.uuid_generate_v5(uuid, text);

CREATE OR REPLACE FUNCTION public.uuid_generate_v5(namespace uuid, name text)
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v5$function$
;

-- DROP FUNCTION public.uuid_nil();

CREATE OR REPLACE FUNCTION public.uuid_nil()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_nil$function$
;

-- DROP FUNCTION public.uuid_ns_dns();

CREATE OR REPLACE FUNCTION public.uuid_ns_dns()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_dns$function$
;

-- DROP FUNCTION public.uuid_ns_oid();

CREATE OR REPLACE FUNCTION public.uuid_ns_oid()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_oid$function$
;

-- DROP FUNCTION public.uuid_ns_url();

CREATE OR REPLACE FUNCTION public.uuid_ns_url()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_url$function$
;

-- DROP FUNCTION public.uuid_ns_x500();

CREATE OR REPLACE FUNCTION public.uuid_ns_x500()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_x500$function$
;

insert into  dim_time
SELECT  
	cast(to_char(minute, 'hh24mi') as numeric) time_id,
	to_char(minute, 'hh24:mi')::time AS tume_actual,
	-- Hour of the day (0 - 23)
	to_char(minute, 'hh24') AS hour_24,
	-- Hour of the day (0 - 11)
	to_char(minute, 'hh12') hour_12,
	-- Hour minute (0 - 59)
	to_char(minute, 'mi') hour_minutes,
	-- Minute of the day (0 - 1439)
	extract(hour FROM minute)*60 + extract(minute FROM minute) day_minutes,
	-- Names of day periods
	case 
		when to_char(minute, 'hh24:mi') BETWEEN '00:00' AND '11:59'
		then 'AM'
		when to_char(minute, 'hh24:mi') BETWEEN '12:00' AND '23:59'
		then 'PM'
	end AS day_time_name,
	-- Indicator of day or night
	case 
		when to_char(minute, 'hh24:mi') BETWEEN '07:00' AND '19:59' then 'Day'	
		else 'Night'
	end AS day_night
FROM 
	(SELECT '0:00'::time + (sequence.minute || ' minutes')::interval AS minute 
	FROM  generate_series(0,1439) AS sequence(minute)
GROUP BY sequence.minute
) DQ
ORDER BY 1;


INSERT INTO dim_date
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
       datum AS date_actual,
       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_name,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW') AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum, 'TMMonth') AS month_name,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_actual,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year_actual,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN 'weekend'
           ELSE 'weekday'
           END AS weekend_indr
FROM (SELECT '1998-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;