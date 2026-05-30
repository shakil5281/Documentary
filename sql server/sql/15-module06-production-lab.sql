/*
================================================================================
 15 - MODULE 6 LAB: PRODUCTION READINESS CHECKLIST
 Prerequisite: sql/01, sql/09 (or run this standalone after 01)
 Creates: dbo.ProductionReadinessCheck — run results for your instance
================================================================================
*/

USE LearnSQL;
GO

IF OBJECT_ID(N'dbo.ProductionReadinessCheck', N'U') IS NOT NULL
    DROP TABLE dbo.ProductionReadinessCheck;
GO

CREATE TABLE dbo.ProductionReadinessCheck (
    CheckId     INT IDENTITY(1,1) PRIMARY KEY,
    Category    NVARCHAR(50)  NOT NULL,
    CheckName   NVARCHAR(100) NOT NULL,
    Status      NVARCHAR(20)  NOT NULL,  -- PASS, WARN, FAIL, INFO
    Details     NVARCHAR(500) NULL,
    CheckedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

DECLARE @Status NVARCHAR(20), @Details NVARCHAR(500);

-- ========== 1) Recovery model ==========
SELECT @Status = CASE recovery_model_desc WHEN N'FULL' THEN N'PASS' ELSE N'WARN' END,
       @Details = N'Current: ' + recovery_model_desc
FROM sys.databases WHERE name = N'LearnSQL';

INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Backup', N'RecoveryModel', @Status, @Details);

-- ========== 2) Last backup (msdb) ==========
IF EXISTS (SELECT 1 FROM msdb.sys.tables WHERE name = N'backupset')
BEGIN
    SET @Status = NULL;
    SET @Details = NULL;

    SELECT TOP 1
        @Status = CASE WHEN backup_finish_date > DATEADD(DAY, -7, GETDATE()) THEN N'PASS' ELSE N'WARN' END,
        @Details = N'Type=' + CAST(type AS NVARCHAR(10)) + N', Finished=' + CONVERT(NVARCHAR(30), backup_finish_date, 120)
    FROM msdb.dbo.backupset
    WHERE database_name = N'LearnSQL'
    ORDER BY backup_finish_date DESC;

    IF @Details IS NULL
    BEGIN
        SET @Status = N'FAIL';
        SET @Details = N'No backup history for LearnSQL in msdb';
    END

    INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
    VALUES (N'Backup', N'RecentFullBackup', @Status, @Details);
END
ELSE
    INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
    VALUES (N'Backup', N'RecentFullBackup', N'INFO', N'msdb backupset not available');

-- ========== 3) Integrity check age (INFO — run CHECKDB regularly) ==========
INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Integrity', N'CheckDB', N'INFO', N'Run DBCC CHECKDB weekly; see script 09/12');

-- ========== 4) Auto update statistics ==========
SELECT @Status = CASE is_auto_update_stats_on WHEN 1 THEN N'PASS' ELSE N'WARN' END,
       @Details = N'is_auto_update_stats_on=' + CAST(is_auto_update_stats_on AS NVARCHAR(1))
FROM sys.databases WHERE name = N'LearnSQL';

INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Maintenance', N'AutoUpdateStatistics', @Status, @Details);

-- ========== 5) Orphaned users (INFO) ==========
INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Security', N'DatabaseUsers', N'INFO',
    N'User count: ' + CAST((SELECT COUNT(*) FROM sys.database_principals WHERE type IN (N'S','U','G')) AS NVARCHAR(10)));

-- ========== 6) Tables without clustered index (WARN) ==========
DECLARE @HeapCount INT = (
    SELECT COUNT(*)
    FROM sys.tables t
    WHERE t.is_ms_shipped = 0
      AND NOT EXISTS (
          SELECT 1 FROM sys.indexes i
          WHERE i.object_id = t.object_id AND i.type = 1
      )
);

INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Design', N'HeapTables',
    CASE WHEN @HeapCount = 0 THEN N'PASS' ELSE N'WARN' END,
    N'Heap table count (no clustered index): ' + CAST(@HeapCount AS NVARCHAR(10)));

-- ========== 7) Environment label (manual) ==========
INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Process', N'Environment', N'INFO', N'Label this instance: DEV / TEST / STAGING / PROD');

-- ========== 8) RPO/RTO documented (manual) ==========
INSERT INTO dbo.ProductionReadinessCheck (Category, CheckName, Status, Details)
VALUES (N'Process', N'RecoveryObjectives', N'INFO',
    N'Document RPO (max data loss) and RTO (max downtime) in runbook');

GO

-- ========== Report ==========
SELECT Category, CheckName, Status, Details, CheckedAt
FROM dbo.ProductionReadinessCheck
ORDER BY
    CASE Status WHEN N'FAIL' THEN 1 WHEN N'WARN' THEN 2 WHEN N'PASS' THEN 3 ELSE 4 END,
    Category, CheckId;

SELECT Status, COUNT(*) AS Cnt
FROM dbo.ProductionReadinessCheck
GROUP BY Status
ORDER BY Cnt DESC;

PRINT N'=== Fix all FAIL/WARN before calling a database PRODUCTION ===';
GO

-- ========== Maintenance log entry ==========
IF OBJECT_ID(N'dbo.MaintenanceLog', N'U') IS NOT NULL
    INSERT INTO dbo.MaintenanceLog (TaskName, Details)
    VALUES (N'ProductionReadinessCheck', N'Module 6 lab executed');

GO
