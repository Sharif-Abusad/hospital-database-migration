-- =====================================================================
-- File    : 01_schema/02_create_tables.sql
-- Purpose : Create all core tables of the hospital database.
-- Run     : After 01_create_database.sql.
-- Design  : * Every table has an AUTO_INCREMENT primary key
--             (Problem 1: unique identifiers).
--           * Foreign keys link the tables together
--             (Problem 2: referential integrity).
--           * CHECK constraints restrict values
--             (Problem 3: invalid or ambiguous data).
--           * Tables are created in dependency order: a table must
--             exist before another table can reference it.
-- =====================================================================

USE hospital_db;

-- ---------------------------------------------------------------------
-- DEPARTMENTS
-- Parent table for doctors (no dependencies of its own).
-- ---------------------------------------------------------------------
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,   -- unique department ID
    name          VARCHAR(50) NOT NULL              -- department name, required
);

-- ---------------------------------------------------------------------
-- DOCTORS
-- Each doctor belongs to one department.
-- `role` is used by the access-control procedure to tell senior
-- doctors apart from other doctors.
-- ---------------------------------------------------------------------
CREATE TABLE doctors (
    doctor_id      INT AUTO_INCREMENT PRIMARY KEY,  -- unique doctor ID
    name           VARCHAR(50),
    specialization VARCHAR(100),
    role           VARCHAR(50),                     -- e.g. 'senior'
    department_id  INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ---------------------------------------------------------------------
-- PATIENTS
-- Gender is limited to M / F / O by a CHECK constraint
-- (MySQL's default collation is case-insensitive, so 'm' also passes).
-- ---------------------------------------------------------------------
CREATE TABLE patients (
    patient_id  INT AUTO_INCREMENT PRIMARY KEY,     -- unique patient ID
    name        VARCHAR(50),
    dateofbirth DATE,
    gender      VARCHAR(1),
    phone       VARCHAR(15),
    CHECK (gender IN ('M', 'F', 'O'))
);

-- ---------------------------------------------------------------------
-- APPOINTMENTS
-- Links a patient to a doctor at a given time.
-- Status is limited to three values by a CHECK constraint.
-- Past-dated and double-booked appointments are blocked by the
-- trigger in 03_business_rules/trg_check_new_appointment.sql.
-- ---------------------------------------------------------------------
CREATE TABLE appointments (
    appointment_id   INT AUTO_INCREMENT PRIMARY KEY,
    patient_id       INT,
    doctor_id        INT,
    appointment_time DATETIME,
    status           VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id),
    CHECK (status IN ('Scheduled', 'Completed', 'Cancelled'))
);

-- ---------------------------------------------------------------------
-- PRESCRIPTIONS
-- Medication prescribed during an appointment.
-- ---------------------------------------------------------------------
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT,
    medication      VARCHAR(100),
    dosage          VARCHAR(100),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- ---------------------------------------------------------------------
-- BILLS
-- One bill per appointment. `paid` is a flag: 1 = paid, 0 = unpaid.
-- bill_date defaults to the current time and drives the monthly
-- revenue report.
-- ---------------------------------------------------------------------
CREATE TABLE bills (
    bill_id        INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    amount         DECIMAL(10, 2),                  -- exact money value
    paid           TINYINT(1),
    bill_date      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- ---------------------------------------------------------------------
-- LAB_REPORTS
-- Lab results attached to an appointment.
-- ---------------------------------------------------------------------
CREATE TABLE lab_reports (
    report_id      INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    report_data    TEXT,                            -- free-text report content
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);