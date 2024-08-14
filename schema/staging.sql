-- DROP SCHEMA public;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP SEQUENCE public.appointment_appointment_id_seq;

CREATE SEQUENCE public.appointment_appointment_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.appointment_appointment_id_seq1;

CREATE SEQUENCE public.appointment_appointment_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.doctor_doctor_id_seq;

CREATE SEQUENCE public.doctor_doctor_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.doctor_doctor_id_seq1;

CREATE SEQUENCE public.doctor_doctor_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.employee_employee_id_seq;

CREATE SEQUENCE public.employee_employee_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.employee_employee_id_seq1;

CREATE SEQUENCE public.employee_employee_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.equipment_equipment_id_seq;

CREATE SEQUENCE public.equipment_equipment_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.equipment_equipment_id_seq1;

CREATE SEQUENCE public.equipment_equipment_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.leave_requests_leave_id_seq;

CREATE SEQUENCE public.leave_requests_leave_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.leave_requests_leave_id_seq1;

CREATE SEQUENCE public.leave_requests_leave_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.maintenance_record_record_id_seq;

CREATE SEQUENCE public.maintenance_record_record_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.maintenance_record_record_id_seq1;

CREATE SEQUENCE public.maintenance_record_record_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.maintenance_request_id_seq;

CREATE SEQUENCE public.maintenance_request_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.medication_medication_id_seq;

CREATE SEQUENCE public.medication_medication_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.medication_medication_id_seq1;

CREATE SEQUENCE public.medication_medication_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.patient_patient_id_seq;

CREATE SEQUENCE public.patient_patient_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.patient_patient_id_seq1;

CREATE SEQUENCE public.patient_patient_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.prescription_prescription_id_seq;

CREATE SEQUENCE public.prescription_prescription_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.prescription_prescription_id_seq1;

CREATE SEQUENCE public.prescription_prescription_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.role_role_id_seq;

CREATE SEQUENCE public.role_role_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.role_role_id_seq1;

CREATE SEQUENCE public.role_role_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.salary_salary_id_seq;

CREATE SEQUENCE public.salary_salary_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.salary_salary_id_seq1;

CREATE SEQUENCE public.salary_salary_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.speciality_ops_speciality_id_seq;

CREATE SEQUENCE public.speciality_ops_speciality_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.speciality_speciality_id_seq;

CREATE SEQUENCE public.speciality_speciality_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.speciality_speciality_id_seq1;

CREATE SEQUENCE public.speciality_speciality_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.equipment definition

-- Drop table

-- DROP TABLE equipment;

CREATE TABLE equipment (
	equipment_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	serial_number varchar(100) NOT NULL,
	purchase_date date NOT NULL,
	warranty_expiration date NULL,
	"location" varchar(255) NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT equipment_pkey PRIMARY KEY (equipment_id),
	CONSTRAINT equipment_serial_number_key UNIQUE (serial_number)
);


-- public.maintenance_request definition

-- Drop table

-- DROP TABLE maintenance_request;

CREATE TABLE maintenance_request (
	id serial4 NOT NULL,
	"name" varchar(255) NULL,
	serial_number varchar(50) NULL,
	request_date date NULL,
	"location" varchar(100) NULL,
	request_note text NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT maintenance_request_pkey PRIMARY KEY (id)
);


-- public.medication definition

-- Drop table

-- DROP TABLE medication;

CREATE TABLE medication (
	medication_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	manufacturer varchar(255) NOT NULL,
	dosage_form varchar(50) NOT NULL,
	strength varchar(50) NOT NULL,
	description text NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT medication_pkey PRIMARY KEY (medication_id)
);


-- public.patient definition

-- Drop table

-- DROP TABLE patient;

CREATE TABLE patient (
	patient_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	dob date NOT NULL,
	gender varchar NOT NULL,
	phone_number varchar NOT NULL,
	address varchar(255) NOT NULL,
	state_code varchar(5) NULL DEFAULT NULL::character varying,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT patient_pkey PRIMARY KEY (patient_id)
);


-- public."role" definition

-- Drop table

-- DROP TABLE "role";

CREATE TABLE "role" (
	role_id serial4 NOT NULL,
	"name" varchar(50) NOT NULL,
	description text NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT role_pkey PRIMARY KEY (role_id)
);


-- public.speciality definition

-- Drop table

-- DROP TABLE speciality;

CREATE TABLE speciality (
	speciality_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT speciality_pkey PRIMARY KEY (speciality_id)
);


-- public.speciality_ops definition

-- Drop table

-- DROP TABLE speciality_ops;

CREATE TABLE speciality_ops (
	speciality_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT speciality_ops_pkey PRIMARY KEY (speciality_id)
);


-- public.doctor definition

-- Drop table

-- DROP TABLE doctor;

CREATE TABLE doctor (
	doctor_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	phone_number varchar(20) NOT NULL,
	speciality_id int4 NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT doctor_pkey PRIMARY KEY (doctor_id),
	CONSTRAINT speciality_fk1 FOREIGN KEY (speciality_id) REFERENCES speciality(speciality_id)
);


-- public.employee definition

-- Drop table

-- DROP TABLE employee;

CREATE TABLE employee (
	employee_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	phone_number varchar NOT NULL,
	speciality_id int4 NULL,
	role_id int4 NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT emp_pkey PRIMARY KEY (employee_id),
	CONSTRAINT role_fk1 FOREIGN KEY (role_id) REFERENCES "role"(role_id),
	CONSTRAINT speciality_fk1 FOREIGN KEY (speciality_id) REFERENCES speciality(speciality_id)
);


-- public.leave_requests definition

-- Drop table

-- DROP TABLE leave_requests;

CREATE TABLE leave_requests (
	leave_id serial4 NOT NULL,
	employee_id int4 NULL,
	leave_type varchar(50) NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	status varchar(20) NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT leave_requests_pkey PRIMARY KEY (leave_id),
	CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);


-- public.maintenance_record definition

-- Drop table

-- DROP TABLE maintenance_record;

CREATE TABLE maintenance_record (
	record_id serial4 NOT NULL,
	equipment_id int4 NULL,
	maintenance_date date NOT NULL,
	description text NOT NULL,
	"cost" varchar NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT maintenance_record_pkey PRIMARY KEY (record_id),
	CONSTRAINT maintenance_record_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);


-- public.salary definition

-- Drop table

-- DROP TABLE salary;

CREATE TABLE salary (
	salary_id serial4 NOT NULL,
	employee_id int4 NULL,
	amount numeric NOT NULL,
	payment_date date NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT salary_pkey PRIMARY KEY (salary_id),
	CONSTRAINT salary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);


-- public.appointment definition

-- Drop table

-- DROP TABLE appointment;

CREATE TABLE appointment (
	appointment_id serial4 NOT NULL,
	patient_id int4 NOT NULL,
	doctor_id int4 NOT NULL,
	appointment_date timestamp NOT NULL,
	notes text NULL,
	status varchar(20) NULL DEFAULT NULL::character varying,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id),
	CONSTRAINT appointment_ibfk_1 FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
	CONSTRAINT appointment_ibfk_2 FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
);


-- public.prescription definition

-- Drop table

-- DROP TABLE prescription;

CREATE TABLE prescription (
	prescription_id serial4 NOT NULL,
	appointment_id int4 NOT NULL,
	medication_id int4 NOT NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT prescription_pkey PRIMARY KEY (prescription_id),
	CONSTRAINT am_fk_appointment FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
	CONSTRAINT am_fk_medicine FOREIGN KEY (medication_id) REFERENCES medication(medication_id)
);