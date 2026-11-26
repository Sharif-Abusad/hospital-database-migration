-- =====================================================================
-- File    : 01_schema/03_security_tables.sql
-- Purpose : Create the table that stores doctor login credentials.
--           It is used by the access-control procedure
--           (04_access_control/sp_view_doctor_data.sql).
-- Run     : After 02_create_tables.sql (it references doctors).
-- Note    : This table was used in the original script but its
--           CREATE statement was missing. If you already have a
--           doctor_credentials table, keep yours and skip this file.
-- =====================================================================

USE hospital_db;

CREATE TABLE IF NOT EXISTS doctor_credentials (
    doctor_id INT PRIMARY KEY,                      -- one login per doctor
    user_name VARCHAR(100) NOT NULL UNIQUE,         -- login name, must be unique
    password  VARCHAR(100) NOT NULL,                -- see security note below
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- SECURITY NOTE:
-- Plain-text passwords are acceptable for a learning project only.
-- In a real system store a hash (e.g. SHA2(password, 256)) and compare
-- hashes instead of raw passwords.