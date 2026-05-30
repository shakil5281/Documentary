/*
================================================================================
 03 - DML CRUD (SELECT, INSERT, UPDATE, DELETE)
 *** PRODUCTION WARNING: DELETE/UPDATE without WHERE affects all rows ***
 Prerequisite: sql/01-02 | Exercises: exercises/module-02.md
================================================================================
*/

USE LearnSQL;
GO

-- ========== SELECT basics ==========
SELECT CustomerId, FullName, Email, CreatedAt
FROM dbo.Customer
WHERE IsActive = 1
ORDER BY FullName;

-- ========== INSERT ==========
INSERT INTO dbo.Customer (Email, FullName, Phone)
VALUES (N'dave@example.com', N'Dave Ortiz', N'+1-555-0100');

SELECT SCOPE_IDENTITY() AS NewCustomerId;

-- ========== UPDATE (always use WHERE) ==========
UPDATE dbo.Customer
SET Notes = N'VIP customer'
WHERE Email = N'alice@example.com';

-- Preview before delete
SELECT * FROM dbo.Customer WHERE Email = N'dave@example.com';

-- ========== DELETE ==========
DELETE FROM dbo.Customer
WHERE Email = N'dave@example.com';

-- ========== MERGE (upsert pattern) ==========
MERGE reporting.DailyOrderSummary AS target
USING (
    SELECT CAST(OrderDate AS DATE) AS SummaryDate,
           COUNT(*) AS OrderCount,
           SUM(OrderTotal) AS Revenue
    FROM dbo.[Order]
    GROUP BY CAST(OrderDate AS DATE)
) AS source
ON target.SummaryDate = source.SummaryDate
WHEN MATCHED THEN
    UPDATE SET OrderCount = source.OrderCount, Revenue = source.Revenue
WHEN NOT MATCHED THEN
    INSERT (SummaryDate, OrderCount, Revenue)
    VALUES (source.SummaryDate, source.OrderCount, source.Revenue);

SELECT * FROM reporting.DailyOrderSummary ORDER BY SummaryDate;

-- ========== TOP and pagination ==========
SELECT TOP (5) OrderId, OrderTotal, OrderDate
FROM dbo.[Order]
ORDER BY OrderTotal DESC;

SELECT OrderId, OrderTotal
FROM dbo.[Order]
ORDER BY OrderId
OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;

GO

/* ========== EXERCISE BLOCK (Module 02) ==========
-- Preview then UPDATE one customer city
-- INSERT a test row then DELETE only that row by primary key
========== end exercise block ========== */
