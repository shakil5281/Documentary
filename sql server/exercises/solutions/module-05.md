# Module 05 Solutions

```sql
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01';

CREATE NONCLUSTERED INDEX IX_Order_Customer_Covering
ON dbo.[Order](CustomerId) INCLUDE (OrderTotal, OrderDate);
```

3–4. Run scripts 17 and 24; record reads from Messages and Query Store DMVs.
