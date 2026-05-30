/*
================================================================================
 22 - TEMPDB & INSTANCE CONFIG (Module 07)
 Read-only recommendations + safe queries. Avoid changing prod without change control.
================================================================================
*/

SELECT name, physical_name, size * 8 / 1024 AS SizeMB, growth * 8 / 1024 AS GrowthMB
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');

SELECT COUNT(*) AS TempdbDataFiles
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb') AND type = 0;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'max server memory (MB)';
EXEC sp_configure 'max degree of parallelism';
EXEC sp_configure 'cost threshold for parallelism';

SELECT sqlserver_start_time, cpu_count, physical_memory_kb / 1024 AS physical_memory_mb
FROM sys.dm_os_sys_info;

PRINT N'TempDB guidance: multiple equal-sized data files (often 4-8); pre-size to reduce autogrowth.';
PRINT N'MAXDOP: often 4-8 for OLTP; test before changing production.';
GO
