/*
================================================================================
 12 - MODULE 3 LAB: BACKUP, RESTORE, MONITORING
 Prerequisite: sql/01-create-sample-database.sql
 BEFORE RUNNING: Create folder C:\Temp\SqlBackups (or change @BackupFolder below)
================================================================================
*/

USE master;
GO

DECLARE @BackupFolder NVARCHAR(260) = N'C:\Temp\SqlBackups';
DECLARE @BackupFile   NVARCHAR(500) =
    @BackupFolder + N'\LearnSQL_' + CONVERT(CHAR(8), GETDATE(), 112) + N'_lab.bak';

PRINT N'=== MODULE 3 LAB ===';
PRINT N'Backup file: ' + @BackupFile;
GO

-- ========== 1) Instance & database inventory ==========
SELECT
    @@SERVERNAME AS ServerName,
    @@VERSION AS VersionShort,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;

SELECT
    name AS DatabaseName,
    recovery_model_desc AS RecoveryModel,
    state_desc AS State,
    compatibility_level AS CompatLevel
FROM sys.databases
WHERE database_id > 4  -- user DBs
   OR name IN (N'LearnSQL', N'LibraryDB')
ORDER BY name;
GO

USE LearnSQL;
GO

-- ========== 2) Recovery model (production uses FULL) ==========
ALTER DATABASE LearnSQL SET RECOVERY FULL;
SELECT name, recovery_model_desc FROM sys.databases WHERE name = N'LearnSQL';
GO

-- ========== 3) Full backup (requires folder to exist) ==========
DECLARE @BackupFile NVARCHAR(500) = N'C:\Temp\SqlBackups\LearnSQL_' + CONVERT(CHAR(8), GETDATE(), 112) + N'_lab.bak';

BEGIN TRY
    BACKUP DATABASE LearnSQL
    TO DISK = @BackupFile
    WITH COMPRESSION, CHECKSUM, INIT, STATS = 10;

    PRINT N'Backup OK: ' + @BackupFile;
END TRY
BEGIN CATCH
    PRINT N'Backup skipped — create C:\Temp\SqlBackups then re-run section 3.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- ========== 4) Integrity check ==========
DBCC CHECKDB (LearnSQL) WITH NO_INFOMSGS;
PRINT N'CHECKDB completed (no messages = good).';
GO

-- ========== 5) Space usage ==========
EXEC sp_spaceused;

SELECT
    t.name AS TableName,
    SUM(p.rows) AS RowCount,
    SUM(a.total_pages) * 8 / 1024 AS TotalMB
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY t.name
ORDER BY TotalMB DESC;
GO

-- ========== 6) Who is connected? ==========
SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    DB_NAME(r.database_id) AS CurrentDatabase,
    r.command,
    r.wait_type,
    r.blocking_session_id
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_requests r ON r.session_id = s.session_id
WHERE s.is_user_process = 1
ORDER BY s.session_id;
GO

-- ========== 7) Currently running SQL text ==========
SELECT
    r.session_id,
    DB_NAME(r.database_id) AS DbName,
    r.status,
    SUBSTRING(
        t.text,
        (r.statement_start_offset / 2) + 1,
        ((CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(t.text)
          ELSE r.statement_end_offset END - r.statement_start_offset) / 2) + 1
    ) AS RunningStatement
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.session_id <> @@SPID
  AND r.session_id > 50;
GO

-- ========== 8) Wait stats (what slows the server) ==========
SELECT TOP 10
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    max_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE N'SLEEP%'
  AND wait_type NOT LIKE N'LAZYWRITER%'
  AND wait_type NOT LIKE N'SQLTRACE%'
  AND wait_type NOT LIKE N'BROKER%'
ORDER BY wait_time_ms DESC;
GO

-- ========== 9) Restore drill (optional — creates LearnSQL_RestoreTest) ==========
/*
USE master;
ALTER DATABASE LearnSQL_RestoreTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS LearnSQL_RestoreTest;

RESTORE DATABASE LearnSQL_RestoreTest
FROM DISK = N'C:\Temp\SqlBackups\LearnSQL_YYYYMMDD_lab.bak'  -- use your actual file name
WITH MOVE N'LearnSQL' TO N'C:\Temp\SqlBackups\LearnSQL_RestoreTest.mdf',
     MOVE N'LearnSQL_log' TO N'C:\Temp\SqlBackups\LearnSQL_RestoreTest_log.ldf',
     REPLACE, RECOVERY;

SELECT name, create_date FROM sys.databases WHERE name = N'LearnSQL_RestoreTest';
*/

PRINT N'Module 3 lab done. Uncomment section 9 after a successful backup.';
GO
