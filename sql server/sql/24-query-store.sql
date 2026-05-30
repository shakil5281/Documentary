/*
================================================================================
 24 - QUERY STORE (Module 05) - SQL Server 2016+
 Enable on LearnSQL and inspect top resource queries.
================================================================================
*/

USE LearnSQL;
GO

ALTER DATABASE LearnSQL SET QUERY_STORE = ON;
ALTER DATABASE LearnSQL SET QUERY_STORE (
    OPERATION_MODE = READ_WRITE,
    DATA_FLUSH_INTERVAL_SECONDS = 900,
    MAX_STORAGE_SIZE_MB = 200
);
GO

SELECT actual_state_desc, desired_state_desc, current_storage_size_mb
FROM sys.database_query_store_options;

-- Run sample workload
SELECT COUNT(*) FROM dbo.[Order] WHERE CustomerId = 1;
SELECT c.FullName, SUM(o.OrderTotal) FROM dbo.Customer c
JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId GROUP BY c.FullName;
GO

SELECT TOP 10
    q.query_id,
    LEFT(qt.query_sql_text, 200) AS query_text,
    rs.avg_duration / 1000.0 AS avg_duration_ms,
    rs.count_executions
FROM sys.query_store_query q
JOIN sys.query_store_query_text qt ON qt.query_text_id = q.query_text_id
JOIN sys.query_store_plan p ON p.query_id = q.query_id
JOIN sys.query_store_runtime_stats rs ON rs.plan_id = p.plan_id
ORDER BY rs.avg_duration DESC;
GO

PRINT N'Query Store enabled. Compare plans in SSMS: Query Store reports.';
GO
