-- =====================================================================
-- File    : 02_migration/03_migrate_doctors.sql
-- Purpose : Migrate doctor records from the staging table
--           `hospital_data` into the `doctors` table.
-- Run     : After 02_migrate_departments.sql
--           (doctors.department_id references departments).
-- =====================================================================

USE hospital_db;

-- Rows available in staging
SELECT COUNT(*) AS staging_rows FROM hospital_data;

-- Migrate doctors
-- (skip rows where the doctor columns are empty)
INSERT INTO doctors (doctor_id, name, specialization, role, department_id)
SELECT `Doctors.DoctorID`,
       `Doctors.Name`,
       `Doctors.Specialization`,
       `Doctors.Role`,
       `Doctors.DepartmentID`
FROM hospital_data
WHERE `Doctors.DoctorID` <> '';

-- Verify
SELECT COUNT(*) AS doctors_migrated FROM doctors;
SELECT * FROM doctors;