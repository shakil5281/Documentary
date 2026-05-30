# Module 05 Exercises — Performance

1. Rewrite `WHERE YEAR(OrderDate)=2026` as sargable range.
2. Create covering index on `Order(CustomerId)` INCLUDE `(OrderTotal, OrderDate)`.
3. Compare logical reads: correlated subquery vs GROUP BY join (script 17).
4. Enable Query Store (script 24) and query top resource query.
