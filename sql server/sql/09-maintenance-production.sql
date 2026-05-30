/*
================================================================================
 09 - MAINTENANCE & PRODUCTION PATTERNS
 Adjust backup path to a folder that exists on your machine.
 Prerequisite: 01-create-sample-database.sql
================================================================================
*/

USE LearnSQL;
GO

-- ========== Database options ==========
ALTER DATABASE LearnSQL SET RECOVERY FULL;
ALTER DATABASE LearnSQL SET AUTO_UPDATE_STATISTICS ON;
GO

-- ========== Backup (change path!) ==========
DECLARE @BackupFolder NVARCHAR(260) = N'C:\Temp\SqlBackups';
DECLARE @BackupFile   NVARCHAR(500);
DECLARE @Cmd          NVARCHAR(1000);

-- Create folder via xp_cmdshell is disabled by default; create C:\Temp\SqlBackups manually
SET @BackupFile = @BackupFolder + N'\LearnSQL_' + CONVERT(CHAR(8), GETDATE(), 112) + N'.bak';

PRINT N'Backup target: ' + @BackupFile;
PRINT N'Uncomment BACKUP below after creating folder.';

/*
BACKUP DATABASE LearnSQL
TO DISK = @BackupFile
WITH COMPRESSION, CHECKSUM, INIT, STATS = 10;
*/

-- ========== Integrity check ==========
DBCC CHECKDB (LearnSQL) WITH NO_INFOMSGS, ALL_ERRORMSGS;

-- ========== Index maintenance (light reorganize example) ==========
DECLARE @TableName SYSNAME = N'Order';
DECLARE @IndexName SYSNAME = N'IX_Order_OrderDate';
DECLARE @Frag      FLOAT;

SELECT @Frag = ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID(N'dbo.[Order]'), NULL, NULL, N'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE i.name = @IndexName;

IF @Frag IS NOT NULL AND @Frag > 5 AND @Frag < 30
BEGIN
    PRINT N'Reorganize recommended for ' + @IndexName + N' at ' + CAST(@Frag AS VARCHAR(20)) + N'%';
    -- ALTER INDEX IX_Order_OrderDate ON dbo.[Order] REORGANIZE;
END

-- ========== Update statistics ==========
UPDATE STATISTICS dbo.[Order] WITH FULLSCAN;
UPDATE STATISTICS dbo.Customer WITH FULLSCAN;

-- ========== Agent job substitute: simple maintenance log table ==========
IF OBJECT_ID(N'dbo.MaintenanceLog', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.MaintenanceLog (
        LogId        INT IDENTITY(1,1) PRIMARY KEY,
        TaskName     NVARCHAR(100) NOT NULL,
        RunAt        DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
        Details      NVARCHAR(4000) NULL
    );
END

INSERT INTO dbo.MaintenanceLog (TaskName, Details)
VALUES (N'StatisticsUpdate', N'Updated Order and Customer stats');

SELECT TOP 10 * FROM dbo.MaintenanceLog ORDER BY RunAt DESC;

-- ========== Size report ==========
EXEC sp_spaceused;

SELECT
    t.NAME AS TableName,
    SUM(p.rows) AS RowCounts,
    SUM(a.total_pages) * 8 / 1024 AS TotalSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY t.Name
ORDER BY TotalSpaceMB DESC;

GO
