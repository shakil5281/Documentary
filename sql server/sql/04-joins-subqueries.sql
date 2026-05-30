/*
================================================================================
 04 - JOINS, SUBQUERIES, CTEs
 Prerequisite: sql/01 | Exercises: exercises/module-02.md
================================================================================
*/

USE LearnSQL;
GO

-- ========== INNER JOIN ==========
SELECT c.FullName, o.OrderId, o.OrderDate, o.OrderTotal
FROM dbo.Customer AS c
INNER JOIN dbo.[Order] AS o ON o.CustomerId = c.CustomerId
ORDER BY o.OrderDate DESC;

-- ========== LEFT JOIN (customers with no orders) ==========
SELECT c.FullName, o.OrderId
FROM dbo.Customer AS c
LEFT JOIN dbo.[Order] AS o ON o.CustomerId = c.CustomerId
WHERE o.OrderId IS NULL;

-- ========== Multi-table JOIN ==========
SELECT o.OrderId, c.FullName, p.Name AS ProductName, ol.Quantity, ol.LineTotal
FROM dbo.[Order] AS o
INNER JOIN dbo.Customer AS c ON c.CustomerId = o.CustomerId
INNER JOIN dbo.OrderLine AS ol ON ol.OrderId = o.OrderId
INNER JOIN dbo.Product AS p ON p.ProductId = ol.ProductId;

-- ========== Subquery IN ==========
SELECT FullName
FROM dbo.Customer
WHERE CustomerId IN (
    SELECT CustomerId FROM dbo.[Order] WHERE OrderTotal > 500
);

-- ========== Correlated subquery (compare with JOIN in doc 10) ==========
SELECT c.FullName,
       (SELECT COUNT(*) FROM dbo.[Order] o WHERE o.CustomerId = c.CustomerId) AS OrderCount
FROM dbo.Customer c;

-- ========== CTE ==========
WITH RevenueByCustomer AS (
    SELECT o.CustomerId, SUM(o.OrderTotal) AS TotalRevenue
    FROM dbo.[Order] o
    GROUP BY o.CustomerId
)
SELECT c.FullName, r.TotalRevenue
FROM dbo.Customer c
INNER JOIN RevenueByCustomer r ON r.CustomerId = c.CustomerId
ORDER BY r.TotalRevenue DESC;

-- ========== EXISTS ==========
SELECT c.FullName
FROM dbo.Customer c
WHERE EXISTS (
    SELECT 1 FROM dbo.[Order] o
    WHERE o.CustomerId = c.CustomerId AND o.StatusCode = N'OP'
);

-- ========== JSON query ==========
SELECT FullName,
       JSON_VALUE(MetadataJson, '$.tier') AS Tier,
       JSON_VALUE(MetadataJson, '$.country') AS Country
FROM dbo.Customer
WHERE JSON_VALUE(MetadataJson, '$.country') = N'BD';

GO

/* ========== EXERCISE BLOCK (Module 02) ==========
-- Customers with zero orders (LEFT JOIN)
-- CTE: products with total quantity sold > 1
========== end exercise block ========== */
