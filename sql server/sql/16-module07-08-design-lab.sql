/*
================================================================================
 16 - MODULES 7 & 8 LAB: SCHEMA DESIGN + REPORTING QUERIES
 Run sql/11 first for LibraryDB, or this script creates minimal HospitalDB demo.
================================================================================
*/

USE master;
GO

-- ========== Optional: Hospital demo schema (ERD practice) ==========
IF DB_ID(N'HospitalDB') IS NULL
BEGIN
    CREATE DATABASE HospitalDB;
END
GO

USE HospitalDB;
GO

IF OBJECT_ID(N'clinic.Patient', N'U') IS NULL
BEGIN
    CREATE SCHEMA clinic AUTHORIZATION dbo;

    CREATE TABLE clinic.Patient (
        PatientId   INT IDENTITY(1,1) PRIMARY KEY,
        NationalId  NVARCHAR(30) NOT NULL UNIQUE,
        FullName    NVARCHAR(200) NOT NULL,
        BirthDate   DATE NOT NULL
    );

    CREATE TABLE clinic.Doctor (
        DoctorId    INT IDENTITY(1,1) PRIMARY KEY,
        LicenseNo   NVARCHAR(20) NOT NULL UNIQUE,
        FullName    NVARCHAR(200) NOT NULL,
        Specialty   NVARCHAR(100) NOT NULL
    );

    -- M:N Patient-Doctor via Appointment (junction)
    CREATE TABLE clinic.Appointment (
        AppointmentId INT IDENTITY(1,1) PRIMARY KEY,
        PatientId     INT NOT NULL REFERENCES clinic.Patient(PatientId),
        DoctorId      INT NOT NULL REFERENCES clinic.Doctor(DoctorId),
        ApptDate      DATETIME2(0) NOT NULL,
        StatusCode    CHAR(2) NOT NULL DEFAULT 'SC',  -- SC=scheduled, DN=done, CN=cancel
        CONSTRAINT UQ_Appointment UNIQUE (PatientId, DoctorId, ApptDate)
    );

    INSERT INTO clinic.Patient (NationalId, FullName, BirthDate)
    VALUES (N'NID-001', N'Patient One', '1990-01-01'), (N'NID-002', N'Patient Two', '1985-06-15');

    INSERT INTO clinic.Doctor (LicenseNo, FullName, Specialty)
    VALUES (N'DOC-A', N'Dr. Ahmed', N'Cardiology'), (N'DOC-B', N'Dr. Lee', N'General');

    INSERT INTO clinic.Appointment (PatientId, DoctorId, ApptDate, StatusCode)
    VALUES (1, 1, '2026-06-01 09:00', 'SC'), (2, 2, '2026-06-01 10:30', 'SC');

    PRINT N'HospitalDB clinic schema created (ERD practice).';
END
GO

-- ========== 3NF check query: no transitive dependency in one table ==========
SELECT
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id
JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE t.schema_id = SCHEMA_ID(N'clinic')
ORDER BY t.name, c.column_id;
GO

-- ========== Referential integrity report ==========
SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
WHERE fk.parent_object_id IN (
    OBJECT_ID(N'clinic.Appointment'), OBJECT_ID(N'clinic.Patient'), OBJECT_ID(N'clinic.Doctor')
);
GO

-- ========== Library capstone queries (if LibraryDB exists) ==========
IF DB_ID(N'LibraryDB') IS NOT NULL
BEGIN
    USE LibraryDB;

    PRINT N'--- Library: books on loan ---';
    SELECT b.Title, m.FullName, l.DueDate
    FROM library.Loan l
    JOIN library.Book b ON b.BookId = l.BookId
    JOIN library.Member m ON m.MemberId = l.MemberId
    WHERE l.ReturnedDate IS NULL;

    PRINT N'--- Library: overdue ---';
    SELECT m.FullName, b.Title, l.DueDate,
           DATEDIFF(DAY, l.DueDate, CAST(GETDATE() AS DATE)) AS DaysOverdue
    FROM library.Loan l
    JOIN library.Member m ON m.MemberId = l.MemberId
    JOIN library.Book b ON b.BookId = l.BookId
    WHERE l.ReturnedDate IS NULL AND l.DueDate < CAST(GETDATE() AS DATE);

    PRINT N'--- Library: issue + return demo ---';
    EXEC library.usp_IssueLoan @MemberId = 3, @BookId = 1, @LoanDays = 7;

    DECLARE @activeLoan INT = (
        SELECT TOP 1 LoanId FROM library.Loan WHERE MemberId = 3 AND ReturnedDate IS NULL ORDER BY LoanId DESC
    );
    IF @activeLoan IS NOT NULL
        EXEC library.usp_ReturnLoan @LoanId = @activeLoan, @FinePerDay = 2.00;
END
ELSE
    PRINT N'Run sql/11-capstone-library-database.sql for Library exercises.';

GO

PRINT N'Modules 7-8 lab complete. Draw ERD for HospitalDB clinic schema on paper or dbdiagram.io';
GO
