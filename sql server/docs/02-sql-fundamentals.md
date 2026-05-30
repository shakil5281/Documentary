# 02 — SQL Fundamentals (T-SQL for Beginners)

> **Part:** I Foundations | **Week:** 2 | **SQL:** [02](../sql/02-ddl-basics.sql)–[04](../sql/04-joins-subqueries.sql) | **Exercises:** [module-02](../exercises/module-02.md)

## Learning outcomes

1. Use DDL to create tables with constraints  
2. Perform DML with safe `WHERE` clauses  
3. Join multiple tables and write a CTE  
4. Handle NULLs with `ISNULL` / `COALESCE`  

## What is SQL?

**SQL (Structured Query Language)** is the language to define and work with relational data. On SQL Server, the dialect is **T-SQL (Transact-SQL)**.

SQL is grouped by purpose:

| Category | Purpose | Examples |
|----------|---------|----------|
| **DDL** | Define structure | `CREATE TABLE`, `ALTER`, `DROP` |
| **DML** | Change/read data | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** | Permissions | `GRANT`, `DENY`, `REVOKE` |
| **TCL** | Transactions | `BEGIN TRAN`, `COMMIT`, `ROLLBACK` |

---

## Data types (choose correctly)

| Type | Use for | Example |
|------|---------|---------|
| `INT`, `BIGINT` | Whole numbers | `Quantity` |
| `DECIMAL(18,2)` | Money, precise decimals | `Price` |
| `BIT` | True/false (0/1) | `IsActive` |
| `VARCHAR(n)` / `NVARCHAR(n)` | Text (Unicode = `N`) | `Name` |
| `DATE`, `DATETIME2` | Dates/times | `OrderDate` |
| `UNIQUEIDENTIFIER` | GUID keys | `RowGuid` |

**Tip:** Use `DATETIME2` instead of legacy `DATETIME`. Use `NVARCHAR` if you need international characters.

---

## CREATE TABLE (DDL)

Tables live in a **schema** (default: `dbo`).

```sql
CREATE TABLE dbo.Customer (
    CustomerId   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Email        NVARCHAR(256)     NOT NULL,
    FullName     NVARCHAR(200)     NOT NULL,
    CreatedAt    DATETIME2(0)      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email)
);
```

**Concepts:**

- **PRIMARY KEY** — uniquely identifies each row; indexed automatically.
- **IDENTITY** — auto-increment integer (SQL Server–specific).
- **DEFAULT** — value if insert omits column.
- **UNIQUE** — no duplicate emails.
- **NOT NULL** — column must have a value.

---

## INSERT (DML)

```sql
INSERT INTO dbo.Customer (Email, FullName)
VALUES (N'alice@example.com', N'Alice Khan');

-- Insert multiple rows
INSERT INTO dbo.Customer (Email, FullName)
VALUES
    (N'bob@example.com', N'Bob Lee'),
    (N'carol@example.com', N'Carol Diaz');
```

---

## SELECT (read data)

```sql
SELECT CustomerId, FullName, Email
FROM dbo.Customer
WHERE FullName LIKE N'A%'
ORDER BY CreatedAt DESC;
```

| Clause | Role |
|--------|------|
| `SELECT` | Columns to return |
| `FROM` | Table(s) |
| `WHERE` | Filter rows **before** grouping |
| `GROUP BY` | Aggregate per group |
| `HAVING` | Filter **after** grouping |
| `ORDER BY` | Sort result |

### Aggregates

```sql
SELECT COUNT(*) AS TotalCustomers,
       MIN(CreatedAt) AS FirstSignup
FROM dbo.Customer;
```

---

## UPDATE and DELETE

Always test with `SELECT` first:

```sql
-- Preview
SELECT * FROM dbo.Customer WHERE CustomerId = 1;

UPDATE dbo.Customer
SET FullName = N'Alice K. Khan'
WHERE CustomerId = 1;

DELETE FROM dbo.Customer
WHERE CustomerId = 999;  -- safe if ID does not exist
```

**Golden rule:** No `WHERE` on `UPDATE`/`DELETE` = affects **all rows**.

---

## JOINs (combine tables)

Relationships use **foreign keys**:

```sql
-- One customer, many orders
CREATE TABLE dbo.[Order] (
    OrderId      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId   INT NOT NULL REFERENCES dbo.Customer(CustomerId),
    OrderTotal   DECIMAL(18,2) NOT NULL,
    OrderDate    DATE NOT NULL
);
```

```sql
SELECT c.FullName, o.OrderId, o.OrderTotal
FROM dbo.Customer AS c
INNER JOIN dbo.[Order] AS o ON o.CustomerId = c.CustomerId;
```

| Join type | Meaning |
|-----------|---------|
| `INNER JOIN` | Only matching rows both sides |
| `LEFT JOIN` | All from left + matches from right (NULL if no match) |
| `RIGHT JOIN` | Opposite of left |
| `FULL OUTER` | All from both sides |

---

## Subqueries and CTEs

**Subquery in WHERE:**

```sql
SELECT FullName
FROM dbo.Customer
WHERE CustomerId IN (
    SELECT CustomerId FROM dbo.[Order] WHERE OrderTotal > 1000
);
```

**CTE (readable, reusable in one statement):**

```sql
WITH BigOrders AS (
    SELECT CustomerId, SUM(OrderTotal) AS TotalSpent
    FROM dbo.[Order]
    GROUP BY CustomerId
    HAVING SUM(OrderTotal) > 5000
)
SELECT c.FullName, b.TotalSpent
FROM dbo.Customer c
INNER JOIN BigOrders b ON b.CustomerId = c.CustomerId;
```

---

## NULL handling

`NULL` means **unknown**, not zero.

```sql
SELECT FullName,
       ISNULL(Email, N'(no email)') AS EmailDisplay,
       COALESCE(Phone, Mobile, N'N/A') AS Contact
FROM dbo.Customer;
```

Comparisons: use `IS NULL` / `IS NOT NULL`, not `= NULL`.

---

## Set operations

```sql
SELECT Email FROM dbo.Customer
INTERSECT
SELECT Email FROM dbo.ArchiveCustomer;
```

`UNION` (distinct), `UNION ALL` (keep duplicates), `EXCEPT`, `INTERSECT`.

---

## Common mistakes

| Mistake | Fix |
|---------|-----|
| `UPDATE`/`DELETE` without `WHERE` | Always filter; test with `SELECT` first |
| `= NULL` instead of `IS NULL` | Use `IS NULL` / `IS NOT NULL` |
| `SELECT *` in production APIs | List columns explicitly |

## Practice exercises

[exercises/module-02.md](../exercises/module-02.md)

1. Add a `Phone` column with `ALTER TABLE`.
2. Write a query: customers with **no** orders (`LEFT JOIN` + `WHERE o.OrderId IS NULL`).
3. Count orders per customer (`GROUP BY`).
4. Find the top 3 customers by total spend (`ORDER BY` + `OFFSET/FETCH`).

**Scripts:** [sql/02-ddl-basics.sql](../sql/02-ddl-basics.sql), [sql/03-dml-crud.sql](../sql/03-dml-crud.sql), [sql/04-joins-subqueries.sql](../sql/04-joins-subqueries.sql)

---

## Next

[03-server-management.md](03-server-management.md)
