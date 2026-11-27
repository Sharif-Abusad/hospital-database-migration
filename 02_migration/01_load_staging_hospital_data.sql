-- =====================================================================
-- File    : 02_migration/01_load_staging_hospital_data.sql
-- Purpose : Create the staging table `hospital_data` and load the raw
--           Excel/CSV export into it. Every later migration script
--           reads from this table.
-- Run     : After 01_schema/*, before any 02_migrate_*.sql file.
-- =====================================================================

USE hospital_db;

-- ---------------------------------------------------------------------
-- 1. Staging table
--    The Excel sheet is flattened: each source table has its own
--    columns, and a row only fills the columns of one table (the rest
--    stay empty). All columns are text so nothing is rejected on load;
--    types are converted during migration (STR_TO_DATE, etc.).
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS hospital_data;

CREATE TABLE hospital_data (
    -- Departments
    `Departments.DepartmentID`      VARCHAR(20),
    `Departments.Name`              VARCHAR(100),

    -- Doctors
    `Doctors.DoctorID`              VARCHAR(20),
    `Doctors.Name`                  VARCHAR(100),
    `Doctors.Specialization`        VARCHAR(100),
    `Doctors.Role`                  VARCHAR(50),
    `Doctors.DepartmentID`          VARCHAR(20),

    -- Patients
    `Patients.PatientID`            VARCHAR(20),
    `Patients.Name`                 VARCHAR(100),
    `Patients.DateOfBirth`          VARCHAR(20),
    `Patients.Gender`               VARCHAR(10),
    `Patients.Phone`                VARCHAR(30),

    -- Appointments
    `Appointments.AppointmentID`    VARCHAR(20),
    `Appointments.PatientID`        VARCHAR(20),
    `Appointments.DoctorID`         VARCHAR(20),
    `Appointments.AppointmentTime`  VARCHAR(30),
    `Appointments.Status`           VARCHAR(50),

    -- Prescriptions
    `Prescriptions.PrescriptionID`  VARCHAR(20),
    `Prescriptions.AppointmentID`   VARCHAR(20),
    `Prescriptions.Medication`      VARCHAR(100),
    `Prescriptions.Dosage`          VARCHAR(100),

    -- Lab reports
    `LabReports.ReportID`           VARCHAR(20),
    `LabReports.AppointmentID`      VARCHAR(20),
    `LabReports.ReportData`         TEXT,
    `LabReports.CreatedAt`          VARCHAR(30),

    -- Bills
    `Bills.BillID`                  VARCHAR(20),
    `Bills.AppointmentID`           VARCHAR(20),
    `Bills.Amount`                  VARCHAR(20),
    `Bills.BillDate`                VARCHAR(30),
    `Bills.Paid`                    VARCHAR(5)
);

-- ---------------------------------------------------------------------
-- 2. Load the data
--    Option A: Workbench -> right-click the table -> "Table Data Import
--              Wizard" and pick your CSV (export the Excel sheet as CSV).
--    Option B: LOAD DATA (update the path to your CSV file).
-- ---------------------------------------------------------------------
-- LOAD DATA LOCAL INFILE '/path/to/hospital_data.csv'
-- INTO TABLE hospital_data
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- ---------------------------------------------------------------------
-- 3. Verify the load
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS total_rows_loaded FROM hospital_data;

-- Preview the columns that belong to each source table
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'hospital_db'
  AND TABLE_NAME   = 'hospital_data'
ORDER BY ORDINAL_POSITION;