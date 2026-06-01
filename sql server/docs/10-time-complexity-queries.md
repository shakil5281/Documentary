# 05b — Time Complexity & Query Cost

> **Part:** II Developer | **Module ID:** 05 (continued) | **Pair with:** [09-performance-scalability.md](09-performance-scalability.md) | **Exercises:** [module-05](../exercises/module-05.md)

## Learning outcomes

1. Relate scans/seeks to Big O intuition  
2. Rewrite non-sargable predicates  
3. Choose keyset over OFFSET pagination  

In computer science, **Big O** describes how work grows as input size **n** grows. SQL Server’s optimizer picks **physical operators**; your **T-SQL shape** strongly influences cost.

---

## Big O refresher

| Notation | Growth | Example |
|----------|--------|---------|
| O(1) | Constant | Hash seek by PK |
| O(log n) | Logarithmic | B-tree index seek |
| O(n) | Linear | Scan all rows |
| O(n log n) | Linearithmic | Sort large set |
| O(n²) | Quadratic | Nested loops on two huge scans |

**n** = rows touched, not “rows returned.”

---

## Operations in SQL Server (typical)

| Operation | Typical complexity | Notes |
|-----------|-------------------|--------|
| Index seek | O(log n) per seek | B-tree depth |
| Clustered index scan | O(n) | Reads all table rows |
| Nested loop join | O(n × m) worst case | OK if inner is tiny per outer row |
| Merge join | O(n + m) | Needs sorted inputs |
| Hash join | O(n + m) | Builds hash table in memory |
| Sort | O(n log n) | Memory or tempdb spill |
| Aggregate (hash) | O(n) | GROUP BY |

Actual plan depends on **statistics**, **memory**, **parallelism**.

---

## Example: bad vs better

### O(n) scan — no useful index

```sql
SELECT * FROM dbo.[Order] WHERE YEAR(OrderDate) = 2025;
```

Function on column → often **scan** every row.

### O(log n) seek + residual filter

```sql
SELECT * FROM dbo.[Order]
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01';
```

With index on `OrderDate`, seeks date range.

---

## Correlated subquery — can be O(n²)

```sql
SELECT c.CustomerId, c.FullName,
    (SELECT COUNT(*) FROM dbo.[Order] o WHERE o.CustomerId = c.CustomerId) AS Cnt
FROM dbo.Customer c;
```

For each customer, inner work repeats → expensive at scale.

### Often better: O(n) single pass with join

```sql
SELECT c.CustomerId, c.FullName, ISNULL(x.Cnt, 0) AS Cnt
FROM dbo.Customer c
LEFT JOIN (
    SELECT CustomerId, COUNT(*) AS Cnt
    FROM dbo.[Order]
    GROUP BY CustomerId
) x ON x.CustomerId = c.CustomerId;
```

One scan/aggregate of orders + join to customers.

---

## OFFSET pagination — O(offset + fetch)

```sql
SELECT OrderId, OrderTotal
FROM dbo.[Order]
ORDER BY OrderId
OFFSET 1000000 ROWS FETCH NEXT 20 ROWS ONLY;
```

Skipping 1M rows still **reads** them → slow on deep pages.

### Keyset (seek) pagination — O(fetch)

```sql
SELECT TOP (20) OrderId, OrderTotal
FROM dbo.[Order]
WHERE OrderId > @LastSeenOrderId
ORDER BY OrderId;
```

Uses index seek; stable for live feeds.

---

## COUNT(*) on huge table

Full count may scan large index. Options:

- Approximate: `sys.dm_db_partition_stats`
- Cached counter table updated by trigger/job
- Filtered indexes for partial counts

---

## Measuring real cost (not guessing)

```sql
SELECT
    qs.execution_count,
    qs.total_elapsed_time / 1000000.0 AS total_sec,
    qs.total_worker_time / 1000000.0 AS cpu_sec,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY qs.total_elapsed_time DESC;
```

Compare **before/after** index or rewrite.

---

## Complexity checklist for code review

| Question | If yes, investigate |
|----------|---------------------|
| Function on indexed column in WHERE? | Sargability |
| `SELECT *` on wide table? | I/O waste |
| Implicit conversion (varchar vs nvarchar)? | Scan |
| `OR` across different columns? | Index union / scan |
| Cursor row-by-row? | Often O(n) round trips |
| Missing `WHERE` on join? | Cartesian product O(n×m) |

**Sargable** = predicate allows index seek.

---

## Study map

| Topic | Doc | SQL |
|-------|-----|-----|
| Indexes | 09 | 05, 10 |
| Join algorithms | 09, this doc | 04, 10 |
| Plans | 09 | 10 |
| Scale-out | 06, 08, 09 | 09 |

---

## Final practice project

1. Build **Library** ERD (doc 07) and implement in `LearnSQL`.
2. Draw context + Level 1 DFD (doc 08).
3. Load 100k+ rows (script 10) and compare scan vs seek plans.
4. Document backup + security roles for “production” (docs 05–06, script 08–09).

## Exercises

[exercises/module-05.md](../exercises/module-05.md)

## Further reading

- [Microsoft Learn — Query processing](https://learn.microsoft.com/en-us/sql/relational-databases/query-processing-architecture-guide)

---

You now have a full path from **SSMS beginner** to **production-aware advanced developer**.
