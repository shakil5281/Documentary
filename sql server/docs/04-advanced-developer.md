# 04 — Advanced Developer Topics (T-SQL & Database Programming)

> **Part:** II Developer | **SQL:** [05](../sql/05-indexes-views.sql)–[07](../sql/07-triggers-transactions.sql), [13](../sql/13-module04-advanced-lab.sql) | **Exercises:** [module-04](../exercises/module-04.md)

## Learning outcomes

1. Create views, procedures, and functions  
2. Implement TRY/CATCH transactions  
3. Use triggers appropriately  
4. Avoid unsafe dynamic SQL  

After fundamentals, an **advanced SQL Server developer** writes maintainable schema, uses stored logic safely, and understands execution behavior.

---

## Views (virtual tables)

```sql
CREATE VIEW dbo.vw_CustomerOrderSummary
AS
SELECT c.CustomerId, c.FullName,
       COUNT(o.OrderId) AS OrderCount,
       ISNULL(SUM(o.OrderTotal), 0) AS LifetimeValue
FROM dbo.Customer c
LEFT JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FullName;
GO

SELECT * FROM dbo.vw_CustomerOrderSummary WHERE LifetimeValue > 1000;
```

**Indexed views** (materialized, with restrictions) can speed heavy aggregates—see doc 09.

---

## Stored procedures

Encapsulate logic; grant `EXECUTE` without table-level DML rights.

```sql
CREATE PROCEDURE dbo.usp_GetCustomerOrders
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT OrderId, OrderTotal, OrderDate
    FROM dbo.[Order]
    WHERE CustomerId = @CustomerId
    ORDER BY OrderDate DESC;
END;
GO

EXEC dbo.usp_GetCustomerOrders @CustomerId = 1;
```

**Best practices:**

- `SET NOCOUNT ON` — fewer network messages
- Parameterize — avoids SQL injection
- Avoid `SELECT *` in production APIs
- Return one shape per procedure when used by apps

---

## Functions

| Type | Use |
|------|-----|
| **Scalar** | One value per call (e.g. formatting) |
| **Inline TVF** | `RETURNS TABLE` — often optimized well |
| **Multi-statement TVF** | Can be slower; use sparingly |

```sql
CREATE FUNCTION dbo.fn_OrderTotalWithTax (@Amount DECIMAL(18,2), @Rate DECIMAL(5,4))
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @Amount * (1 + @Rate);
END;
```

**Note:** User functions in computed columns/indexes have limitations; scalar UDFs can hurt performance on large sets (SQL Server 2019+ may inline some).

---

## Triggers

Run **automatically** on `INSERT`/`UPDATE`/`DELETE`.

```sql
CREATE TRIGGER dbo.tr_Order_AuditInsert
ON dbo.[Order]
AFTER INSERT
AS
BEGIN
    INSERT INTO dbo.OrderAudit (OrderId, Action, ActionAt)
    SELECT OrderId, N'INSERT', SYSUTCDATETIME() FROM inserted;
END;
```

Prefer **explicit** logic in procedures when possible—triggers are harder to debug.

---

## Transactions and isolation

```sql
BEGIN TRANSACTION;
    UPDATE dbo.Customer SET FullName = N'Test' WHERE CustomerId = 1;
    -- IF something wrong:
    -- ROLLBACK TRANSACTION;
COMMIT TRANSACTION;
```

| Isolation level | Behavior (simplified) |
|-----------------|----------------------|
| READ COMMITTED | Default; no dirty reads |
| REPEATABLE READ | Same row reads consistent in tran |
| SERIALIZABLE | Strictest; more blocking |
| READ UNCOMMITTED | Dirty reads (avoid) |
| SNAPSHOT | Row versioning; readers don't block writers |

Use **short transactions** to reduce blocking.

---

## Error handling (modern pattern)

```sql
BEGIN TRY
    BEGIN TRAN;
        INSERT INTO dbo.[Order] (CustomerId, OrderTotal, OrderDate)
        VALUES (1, -5, '2026-01-01');  -- may fail CHECK constraint
    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;  -- re-raise error
END CATCH;
```

---

## Dynamic SQL (careful)

Only with **parameters**:

```sql
DECLARE @TableName SYSNAME = N'Customer';
DECLARE @Sql NVARCHAR(MAX) = N'SELECT COUNT(*) FROM dbo.' + QUOTENAME(@TableName);
EXEC sp_executesql @Sql;
```

Never concatenate user input into SQL strings.

---

## Temporal tables (SQL Server 2016+)

System-versioned tables keep **history** automatically.

```sql
ALTER TABLE dbo.Customer
ADD ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
    ValidTo   DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);

ALTER TABLE dbo.Customer
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomerHistory));
```

---

## JSON (modern apps)

```sql
SELECT CustomerId, FullName,
       JSON_VALUE(MetadataJson, '$.tier') AS Tier
FROM dbo.Customer
WHERE JSON_VALUE(MetadataJson, '$.country') = N'BD';
```

---

## Advanced developer checklist

- [ ] Schema changes in source control (migrations / SSDT / Flyway)
- [ ] Naming conventions (`usp_`, `fn_`, `tr_`, `ix_`)
- [ ] Idempotent deploy scripts where possible
- [ ] Unit/integration tests for critical procedures
- [ ] Document API contracts (parameters, result sets)

**Scripts:** [sql/05-indexes-views.sql](../sql/05-indexes-views.sql) through [sql/07-triggers-transactions.sql](../sql/07-triggers-transactions.sql)

## Common mistakes

| Mistake | Fix |
|---------|-----|
| `SELECT *` in procedures used by apps | Explicit column list |
| Nested triggers without documentation | Prefer explicit workflow in procs |
| `THROW` missing after CATCH without re-raise | Use `THROW;` to propagate |

## Exercises

[exercises/module-04.md](../exercises/module-04.md)

---

## Next

[05-security.md](05-security.md)
