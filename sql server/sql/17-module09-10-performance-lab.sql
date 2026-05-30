/*
================================================================================
 17 - MODULES 9 & 10 LAB: PLANS, INDEX TUNING, COMPLEXITY
 Prerequisite: sql/01, sql/05 (index on OrderDate), sql/10 recommended
 In SSMS: Query -> Include Actual Execution Plan (Ctrl+M) BEFORE running
================================================================================
*/

USE LearnSQL;
GO

PRINT N'=== MODULES 9 & 10 PERFORMANCE LAB ===';
PRINT N'Enable Actual Execution Plan (Ctrl+M) then run section by section.';
GO

-- ========== 0) Baseline row count ==========
SELECT COUNT(*) AS OrderRows FROM dbo.[Order];
GO

-- ========== 1) SARGABLE vs non-sargable (doc 10) ==========
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

PRINT N'[1a] NON-SARGABLE — function on column (often SCAN, O(n))';
SELECT COUNT(*) AS Cnt FROM dbo.[Order] WHERE YEAR(OrderDate) = 2026;

PRINT N'[1b] SARGABLE — range on indexed column (often SEEK, O(log n + matches))';
SELECT COUNT(*) AS Cnt FROM dbo.[Order]
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- ========== 2) Missing index on filter column (demo) ==========
-- CustomerId may lack covering index for this pattern
PRINT N'[2] Customer filter — check plan for Seek vs Scan on CustomerId';
SET STATISTICS IO ON;
SELECT OrderId, OrderTotal, OrderDate
FROM dbo.[Order]
WHERE CustomerId = 2
ORDER BY OrderDate DESC;
SET STATISTICS IO OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Order_CustomerId_Lab' AND object_id = OBJECT_ID(N'dbo.[Order]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Order_CustomerId_Lab
    ON dbo.[Order] (CustomerId, OrderDate DESC)
    INCLUDE (OrderTotal);
    PRINT N'Created IX_Order_CustomerId_Lab — re-run [2] and compare plan.';
END
GO

-- ========== 3) Correlated subquery vs aggregate (O(n²) vs O(n)) ==========
SET STATISTICS TIME ON;

PRINT N'[3a] Correlated subquery';
SELECT TOP (50) c.CustomerId, c.FullName,
    (SELECT COUNT(*) FROM dbo.[Order] o WHERE o.CustomerId = c.CustomerId) AS Cnt
FROM dbo.Customer c;

PRINT N'[3b] Aggregate + JOIN';
SELECT TOP (50) c.CustomerId, c.FullName, ISNULL(x.Cnt, 0) AS Cnt
FROM dbo.Customer c
LEFT JOIN (
    SELECT CustomerId, COUNT(*) AS Cnt FROM dbo.[Order] GROUP BY CustomerId
) x ON x.CustomerId = c.CustomerId;

SET STATISTICS TIME OFF;
GO

-- ========== 4) OFFSET vs keyset pagination ==========
SET STATISTICS IO ON;

DECLARE @PageOffset INT = 40000, @PageSize INT = 20, @LastId INT = 40000;

PRINT N'[4a] OFFSET deep page — reads and skips many rows';
SELECT OrderId, OrderTotal FROM dbo.[Order]
ORDER BY OrderId OFFSET @PageOffset ROWS FETCH NEXT @PageSize ROWS ONLY;

PRINT N'[4b] Keyset — seek from last id';
SELECT TOP (@PageSize) OrderId, OrderTotal FROM dbo.[Order]
WHERE OrderId > @LastId ORDER BY OrderId;

SET STATISTICS IO OFF;
GO

-- ========== 5) Wait stats snapshot ==========
SELECT TOP 8
    wait_type,
    wait_time_ms / 1000.0 AS wait_sec,
    waiting_tasks_count
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE N'SLEEP%'
  AND wait_type NOT LIKE N'LAZYWRITER%'
  AND wait_type NOT LIKE N'SQLTRACE%'
ORDER BY wait_time_ms DESC;

-- ========== 6) Your turn: fill results table ==========
IF OBJECT_ID(N'dbo.PerformanceLabResults', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PerformanceLabResults (
        TestId      INT IDENTITY(1,1) PRIMARY KEY,
        TestName    NVARCHAR(100) NOT NULL,
        LogicalReads INT NULL,
        ElapsedMs   INT NULL,
        PlanOperator NVARCHAR(100) NULL,
        Notes       NVARCHAR(500) NULL
    );
END

/*
After each test above, note from execution plan:
  - Table Scan vs Index Seek
  - Estimated rows vs Actual rows
Insert your observations:

INSERT INTO dbo.PerformanceLabResults (TestName, PlanOperator, Notes)
VALUES (N'1a YEAR()', N'Table Scan', N'Non-sargable predicate');

SELECT * FROM dbo.PerformanceLabResults;
*/

PRINT N'Lab complete. Run sql/10-performance-tuning.sql for full 50k row dataset if not done.';
GO
