/*
================================================================================
 25 - RESTORE DRILL TEMPLATE (Module 08)
 PRODUCTION WARNING: Use only on DEV. Change paths and database names.
 Prerequisite: Successful BACKUP of LearnSQL to C:\Temp\SqlBackups
================================================================================
*/

USE master;
GO

-- ========== CONFIGURE — edit these ==========
DECLARE @BackupFile NVARCHAR(500) = N'C:\Temp\SqlBackups\LearnSQL_YYYYMMDD_lab.bak';  -- your file
DECLARE @RestoreDb     SYSNAME        = N'LearnSQL_RestoreTest';

-- ========== Inspect backup contents ==========
RESTORE HEADERONLY FROM DISK = @BackupFile;
RESTORE FILELISTONLY FROM DISK = @BackupFile;
GO

-- ========== Restore to test database ==========
/*
ALTER DATABASE LearnSQL_RestoreTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS LearnSQL_RestoreTest;

RESTORE DATABASE LearnSQL_RestoreTest
FROM DISK = @BackupFile
WITH
    MOVE N'LearnSQL'     TO N'C:\Temp\SqlBackups\LearnSQL_RestoreTest.mdf',
    MOVE N'LearnSQL_log' TO N'C:\Temp\SqlBackups\LearnSQL_RestoreTest_log.ldf',
    REPLACE, RECOVERY;
-- Use logical names from FILELISTONLY if different
*/

-- ========== Verify ==========
/*
USE LearnSQL_RestoreTest;
SELECT COUNT(*) AS CustomerCount FROM dbo.Customer;
DBCC CHECKDB (LearnSQL_RestoreTest) WITH NO_INFOMSGS;
*/

PRINT N'Uncomment restore block after setting @BackupFile from your backup.';
GO
