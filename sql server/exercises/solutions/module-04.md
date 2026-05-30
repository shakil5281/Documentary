# Module 04 Solutions

```sql
CREATE OR ALTER VIEW dbo.vw_OpenOrders AS
SELECT o.OrderId, c.FullName, o.OrderTotal FROM dbo.[Order] o
JOIN dbo.Customer c ON c.CustomerId = o.CustomerId WHERE o.StatusCode = N'OP';

CREATE OR ALTER PROCEDURE dbo.usp_CountOrdersByCustomer @CustomerId INT AS
SELECT COUNT(*) AS OrderCount FROM dbo.[Order] WHERE CustomerId = @CustomerId;
```

3. See `sql/13-module04-advanced-lab.sql` `usp_PlaceOrder` pattern.
4. Hidden side effects, hard to debug, unexpected order with nested triggers.
