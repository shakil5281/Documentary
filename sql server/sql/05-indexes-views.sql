/*
================================================================================
 05 - INDEXES AND VIEWS
 Prerequisite: 01-create-sample-database.sql
================================================================================
*/

USE LearnSQL;
GO

-- ========== Covering index (INCLUDE) ==========
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Order_CustomerId_Covering')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Order_CustomerId_Covering
    ON dbo.[Order] (CustomerId, OrderDate DESC)
    INCLUDE (OrderTotal, StatusCode);
END
GO

-- ========== Filtered index ==========
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Customer_ActiveEmail')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_ActiveEmail
    ON dbo.Customer (Email)
    WHERE IsActive = 1;
END
GO

-- ========== View ==========
CREATE OR ALTER VIEW dbo.vw_CustomerLifetimeValue
AS
SELECT
    c.CustomerId,
    c.FullName,
    c.Email,
    COUNT(o.OrderId) AS OrderCount,
    ISNULL(SUM(o.OrderTotal), 0) AS LifetimeValue
FROM dbo.Customer c
LEFT JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FullName, c.Email;
GO

SELECT * FROM dbo.vw_CustomerLifetimeValue ORDER BY LifetimeValue DESC;

-- ========== Index usage stats (after running queries) ==========
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i
    ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE s.database_id = DB_ID()
  AND OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1
ORDER BY s.user_seeks + s.user_scans DESC;

-- ========== Fragmentation check ==========
SELECT
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, N'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count > 100
ORDER BY ips.avg_fragmentation_in_percent DESC;

GO
