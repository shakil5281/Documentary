/*
================================================================================
 10 - PERFORMANCE TUNING & TIME COMPLEXITY DEMOS
 Prerequisite: 01-create-sample-database.sql
 Generates extra rows for plan comparison (dev only).
================================================================================
*/

USE LearnSQL;
GO

SET NOCOUNT ON;

-- ========== Seed large dataset for testing ==========
IF (SELECT COUNT(*) FROM dbo.[Order]) < 50000
BEGIN
    PRINT N'Inserting sample rows for performance demo...';

    ;WITH n AS (
        SELECT TOP (50000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
    SELECT
        1 + (num % 3),
        DATEADD(DAY, - (num % 365), CAST('2026-05-30' AS DATE)),
        (num % 500) * 1.5,
        CASE WHEN num % 10 = 0 THEN 'OP' ELSE 'PD' END
    FROM n;

    PRINT N'Row count: ' + CAST((SELECT COUNT(*) FROM dbo.[Order]) AS VARCHAR(20));
END
GO

-- ========== Non-sargable (often O(n) scan) ==========
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

PRINT N'--- Bad: function on column ---';
SELECT COUNT(*) AS CntBad
FROM dbo.[Order]
WHERE YEAR(OrderDate) = 2026;

PRINT N'--- Good: range seek (with index on OrderDate) ---';
SELECT COUNT(*) AS CntGood
FROM dbo.[Order]
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- ========== Compare correlated subquery vs aggregate JOIN ==========
SET STATISTICS TIME ON;

PRINT N'--- Correlated subquery ---';
SELECT TOP (100) c.CustomerId, c.FullName,
    (SELECT COUNT(*) FROM dbo.[Order] o WHERE o.CustomerId = c.CustomerId) AS OrderCnt
FROM dbo.Customer c;

PRINT N'--- Aggregate + JOIN ---';
SELECT TOP (100) c.CustomerId, c.FullName, ISNULL(x.OrderCnt, 0) AS OrderCnt
FROM dbo.Customer c
LEFT JOIN (
    SELECT CustomerId, COUNT(*) AS OrderCnt
    FROM dbo.[Order]
    GROUP BY CustomerId
) x ON x.CustomerId = c.CustomerId;

SET STATISTICS TIME OFF;

-- ========== OFFSET vs keyset pagination ==========
SET STATISTICS IO ON;

PRINT N'--- OFFSET deep page ---';
SELECT OrderId, OrderTotal
FROM dbo.[Order]
ORDER BY OrderId
OFFSET 40000 ROWS FETCH NEXT 20 ROWS ONLY;

PRINT N'--- Keyset pagination ---';
DECLARE @LastId INT = 40000;
SELECT TOP (20) OrderId, OrderTotal
FROM dbo.[Order]
WHERE OrderId > @LastId
ORDER BY OrderId;

SET STATISTICS IO OFF;

-- ========== Missing index hint (DMV) ==========
SELECT TOP 10
    migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) AS improvement_measure,
    mid.statement AS table_name,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY improvement_measure DESC;

-- ========== Top queries by elapsed time (since restart) ==========
SELECT TOP 10
    qs.execution_count,
    qs.total_elapsed_time / 1000000.0 AS total_elapsed_sec,
    qs.total_worker_time / 1000000.0 AS total_cpu_sec,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE st.dbid = DB_ID()
ORDER BY qs.total_elapsed_time DESC;

/*
IN SSMS: Enable "Include Actual Execution Plan" (Ctrl+M)
Re-run the Good vs Bad date filters and compare Scan vs Seek.
*/

GO
