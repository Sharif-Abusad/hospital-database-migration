-- =====================================================================
-- File    : 01_schema/01_create_database.sql
-- Purpose : Create the hospital database and select it for use.
-- Run     : First file in the project.
-- =====================================================================

-- IF NOT EXISTS lets the script be re-run without an error
CREATE DATABASE IF NOT EXISTS hospital_db;

-- All following statements run against this database
USE hospital_db;