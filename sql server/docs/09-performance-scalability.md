# 05 — Performance, Scalability & High Availability

> **Part:** II Developer | **Module ID:** 05 | **SQL:** [10](../sql/10-performance-tuning.sql), [17](../sql/17-module09-10-performance-lab.sql), [24](../sql/24-query-store.sql) | **Exercises:** [module-05](../exercises/module-05.md)

## Learning outcomes

1. Read execution plans and STATISTICS IO  
2. Design nonclustered and covering indexes  
3. Use Query Store (SQL Server 2016+)  
4. Interpret wait stats and blocking  

**Performance** = how fast queries run under load.  
**Scalability** = how well the system handles growth (more data, users, throughput).  
**Flexibility** = how easily you can change schema and workloads without breaking SLAs.

---

## Performance tuning workflow

```
1. Measure  (wait stats, duration, CPU, I/O)
2. Find bottleneck  (query? disk? lock? network?)
3. Fix root cause  (index, rewrite, hardware, config)
4. Measure again  (prove improvement)
```

Never optimize without metrics.

---

## Execution plans

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT c.FullName, SUM(o.OrderTotal)
FROM dbo.Customer c
INNER JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
GROUP BY c.FullName;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

In SSMS: **Include Actual Execution Plan** (Ctrl+M). Look for:

| Operator warning | Often means |
|------------------|-------------|
| **Table Scan** | Missing index or selective filter missing |
| **Key Lookup** | Consider covering index |
| **Sort / Hash** | Large memory grant; check indexes/stats |
| **Spill to tempdb** | Memory grant too small; bad cardinality estimates |

---

## Indexing strategy

| Index type | Use |
|------------|-----|
| **Clustered** | Usually PK; table physical order |
| **Nonclustered** | Seek on WHERE/JOIN columns |
| **Covering** | `INCLUDE` columns → avoid lookups |
| **Filtered** | Partial index `WHERE IsActive = 1` |
| **Columnstore** | Analytics / large scans |

**Too many indexes** slow `INSERT`/`UPDATE`/`DELETE`.

```sql
CREATE NONCLUSTERED INDEX IX_Order_CustomerId_OrderDate
ON dbo.[Order] (CustomerId, OrderDate DESC)
INCLUDE (OrderTotal);
```

---

## Statistics

Optimizer uses **statistics** to estimate row counts.

```sql
UPDATE STATISTICS dbo.[Order] WITH FULLSCAN;
```

Auto-update helps; after huge loads, update manually.

---

## TempDB

- Multiple data files (common: 1 per CPU up to 8) same size
- Fast disks; pre-size to avoid autogrowth during peak
- Contention on allocation pages — follow Microsoft guidance for your version

---

## Blocking vs deadlocks

- **Blocking** — one session waits for another’s lock (normal briefly)
- **Deadlock** — cycle; SQL Server kills one victim

Reduce: short transactions, consistent lock order, right indexes.

---

## Scalability dimensions

| Scale up (vertical) | Scale out (horizontal) |
|---------------------|-------------------------|
| More CPU/RAM/disk | Read replicas, sharding |
| Simpler | Harder (distributed consistency) |

SQL Server **Always On Availability Groups**:

- Primary for writes
- Secondary for read-only routing
- Automatic failover (cluster)

---

## Partitioning (very large tables)

Split table by range (e.g. year):

```sql
-- Concept: partition function on OrderDate, partition scheme on filegroups
-- Queries that filter by date touch fewer partitions
```

Helps **maintenance** (switch partition out) and **scan reduction**.

---

## Caching layer

- Application cache (Redis) for hot keys
- `OPTION (RECOMPILE)` for skewed parameters (careful)
- Avoid repeating identical heavy queries — parameterize

---

## Hardware & cloud

- **Latency:** app and DB in same region
- **Storage:** SSD/NVMe for OLTP; tiered for archive
- **Azure SQL / Managed Instance** — PaaS scaling, less OS admin

---

## Flexibility without killing performance

| Flexible approach | Performance note |
|-------------------|------------------|
| Add nullable column | Cheap metadata change (SQL 2016+ online) |
| JSON column | Flexible schema; index computed paths |
| Lookup tables | Small, cached |
| Versioned API over views | Hide schema churn |

---

## KPIs to track

- P95 / P99 query duration per endpoint
- Batch requests/sec, compilations/sec
- Page life expectancy (memory pressure)
- Disk latency (read/write ms)
- Wait stats: `PAGEIOLATCH`, `LCK_M_*`, `CXPACKET`

**Script:** [sql/10-performance-tuning.sql](../sql/10-performance-tuning.sql), [sql/24-query-store.sql](../sql/24-query-store.sql)

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Index on every column | Slow writes; index only query paths |
| Ignore outdated statistics | `UPDATE STATISTICS` after large changes |
| Kill long SELECT instead of tuning | Find plan; index or rewrite |

## Exercises

[exercises/module-05.md](../exercises/module-05.md)

---

## Next

[10-time-complexity-queries.md](10-time-complexity-queries.md)
