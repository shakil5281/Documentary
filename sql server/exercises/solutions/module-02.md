# Module 02 Solutions

```sql
USE LearnSQL;
ALTER TABLE dbo.Customer ADD City NVARCHAR(100) NULL;

INSERT INTO dbo.Customer (Email, FullName) VALUES (N'test@ex.com', N'Test User');
UPDATE dbo.Customer SET City = N'Dhaka' WHERE Email = N'test@ex.com';
DELETE FROM dbo.Customer WHERE Email = N'test@ex.com';

SELECT c.FullName FROM dbo.Customer c
LEFT JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId WHERE o.OrderId IS NULL;

SELECT c.FullName, SUM(o.OrderTotal) AS Revenue
FROM dbo.Customer c JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
GROUP BY c.FullName;

WITH Sold AS (SELECT DISTINCT ProductId FROM dbo.OrderLine)
SELECT p.Name FROM dbo.Product p
LEFT JOIN Sold s ON s.ProductId = p.ProductId WHERE s.ProductId IS NULL;
```
