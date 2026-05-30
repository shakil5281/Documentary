/*
================================================================================
 00 - VERIFY SQL SERVER INSTANCE
 Run first after install. No database changes.
================================================================================
*/

SELECT
    @@VERSION AS SqlVersion,
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('EngineEdition') AS EngineEdition;

SELECT name, database_id, state_desc, recovery_model_desc
FROM sys.databases
ORDER BY name;

SELECT
    sqlserver_start_time AS ServiceStartTime,
    cpu_count AS CpuCount,
    physical_memory_kb / 1024 AS PhysicalMemoryMB
FROM sys.dm_os_sys_info;

PRINT N'Instance OK. Next: sql/01-create-sample-database.sql';
GO
