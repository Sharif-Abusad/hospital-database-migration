-- =====================================================================
-- File    : 02_migration/02_migrate_departments.sql
-- Purpose : Migrate department records from the staging table
--           `hospital_data` into the `departments` table.
-- Run     : After 01_load_staging_hospital_data.sql.
--           Must run BEFORE doctors (doctors.department_id references
--           departments.department_id).
-- =====================================================================

USE hospital_db;

-- Rows available in staging
SELECT COUNT(*) AS staging_rows FROM hospital_data;

-- Migrate departments
-- (the staging sheet is flattened, so skip rows where the department
--  columns are empty)
INSERT INTO departments (department_id, name)
SELECT `Departments.DepartmentID`,
       `Departments.Name`
FROM hospital_data
WHERE `Departments.DepartmentID` <> '';

-- Verify
SELECT COUNT(*) AS departments_migrated FROM departments;
SELECT * FROM departments;