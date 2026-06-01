/*
================================================================================
 WEB DEMO QUERIES — SQL Server Learning Hub
 Run in SSMS after sql/01-create-sample-database.sql
 Linked from: web/index.html and WEB-VIEW.md
 Safe for local/dev learning only.
================================================================================
*/

-- ========== 1) Instance snapshot (Module 00) ==========
SELECT
    @@VERSION AS SqlVersion,
    @@SERVERNAME AS ServerName,
    DB_NAME() AS CurrentDatabase;

-- ========== 2) LearnSQL overview (Module 01-02) ==========
USE LearnSQL;
GO

SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT COUNT(*) AS CustomerCount FROM dbo.Customer;
SELECT COUNT(*) AS OrderCount FROM dbo.[Order];

-- ========== 3) JOIN report (Module 02) ==========
SELECT TOP 10
    c.FullName,
    o.OrderId,
    o.OrderDate,
    o.OrderTotal,
    o.StatusCode
FROM dbo.Customer c
INNER JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
ORDER BY o.OrderDate DESC;

-- ========== 4) Revenue by customer (Module 02 / 05) ==========
SELECT
    c.FullName,
    COUNT(o.OrderId) AS OrderCount,
    ISNULL(SUM(o.OrderTotal), 0) AS LifetimeValue
FROM dbo.Customer c
LEFT JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
GROUP BY c.FullName
ORDER BY LifetimeValue DESC;

-- ========== 5) View (Module 04) ==========
IF OBJECT_ID(N'dbo.vw_CustomerLifetimeValue', N'V') IS NOT NULL
    SELECT TOP 5 * FROM dbo.vw_CustomerLifetimeValue ORDER BY LifetimeValue DESC;
ELSE
    PRINT N'Run sql/05-indexes-views.sql to create vw_CustomerLifetimeValue.';

-- ========== 6) Index usage hint (Module 05) ==========
SELECT TOP 5
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE s.database_id = DB_ID()
  AND OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1
ORDER BY s.user_seeks + s.user_scans DESC;

-- ========== 7) Session monitor (Module 10) ==========
SELECT
    session_id,
    login_name,
    status,
    DB_NAME(database_id) AS DbName
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

-- ========== 8) Optional: other capstone DBs ==========
/*
USE LibraryDB;
SELECT TOP 5 * FROM library.vw_ActiveLoans;

USE SchoolDB;
SELECT * FROM school.vw_StudentTranscript;

USE EcommerceDB;
SELECT TOP 5 * FROM shop.vw_OrderSummary;
*/

PRINT N'Web demo queries complete. Open web/index.html for curriculum navigation.';
GO
