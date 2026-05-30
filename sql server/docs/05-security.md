# 09 — SQL Server Security (Development to Production)

> **Part:** III DBA | **Module ID:** 09 (legacy filename `05`) | **SQL:** [08](../sql/08-security-setup.sql), [14](../sql/14-module05-security-lab.sql) | **Exercises:** [module-09](../exercises/module-09.md)

## Learning outcomes

1. Create logins, users, and roles with least privilege  
2. Grant object-level permissions  
3. Explain SQL injection defenses  
4. Describe TDE and auditing at a high level  

Security protects **data**, **availability**, and **compliance**. Treat it as design, not an afterthought.

---

## Security layers

```
Client App
    ↓  (TLS encrypt connection)
SQL Server Login  →  Database User  →  Roles  →  Object permissions
    ↓
Encryption at rest (TDE) / column level
    ↓
Auditing & monitoring
```

---

## Authentication vs authorization

| Term | Meaning |
|------|---------|
| **Authentication** | Who are you? (login validated) |
| **Authorization** | What may you do? (permissions) |

---

## Logins and users

- **Server login** — connects to instance (`CREATE LOGIN`)
- **Database user** — mapped inside a database (`CREATE USER`)
- **Contained database** — users live in DB (portable); special setup

```sql
-- Example: SQL authentication login (learning only; use strong password)
CREATE LOGIN AppReader WITH PASSWORD = N'Change_Me_Str0ng!' MUST_CHANGE;
GO

USE LearnSQL;
CREATE USER AppReader FOR LOGIN AppReader;
ALTER ROLE db_datareader ADD MEMBER AppReader;
```

**Production:** Prefer **Windows/AD groups** or **Azure AD** over SQL logins where possible.

---

## Roles (built-in)

| Role | Typical use |
|------|-------------|
| `db_datareader` | SELECT all user tables |
| `db_datawriter` | INSERT/UPDATE/DELETE |
| `db_ddladmin` | Schema changes (careful) |
| `db_owner` | Full control of database |

**Custom role:**

```sql
CREATE ROLE OrderReportReader;
GRANT SELECT ON dbo.[Order] TO OrderReportReader;
GRANT SELECT ON dbo.Customer TO OrderReportReader;
ALTER ROLE OrderReportReader ADD MEMBER AppReader;
```

**Principle of least privilege:** App that only reads orders gets `SELECT` on those tables—not `db_owner`.

---

## Object-level permissions

```sql
GRANT EXECUTE ON dbo.usp_GetCustomerOrders TO AppReader;
DENY DELETE ON dbo.Customer TO AppReader;  -- DENY wins over GRANT
```

---

## Row-Level Security (RLS)

Filter rows by user automatically:

```sql
CREATE FUNCTION dbo.fn_SecurityPredicate(@CustomerId INT)
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE @CustomerId = CAST(SESSION_CONTEXT(N'CustomerId') AS INT)
   OR IS_ROLEMEMBER(N'db_owner') = 1;
GO

CREATE SECURITY POLICY dbo.CustomerPolicy
ADD FILTER PREDICATE dbo.fn_SecurityPredicate(CustomerId) ON dbo.Customer;
```

App sets `SESSION_CONTEXT` after login.

---

## Dynamic Data Masking

Hide sensitive columns from low-privilege users:

```sql
ALTER TABLE dbo.Customer
ALTER COLUMN Email ADD MASKED WITH (FUNCTION = 'email()');
```

---

## Encryption

| Feature | Protects |
|---------|----------|
| **TLS** | Data in transit |
| **TDE** | Data files at rest (whole DB) |
| **Always Encrypted** | Columns; app holds keys |
| **Column encryption** | Legacy cell-level |

```sql
-- TDE (simplified flow): create DMK, cert, DEK
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TdeCert;

ALTER DATABASE LearnSQL SET ENCRYPTION ON;
```

---

## SQL injection prevention

**Always parameterize:**

```csharp
// Good (ADO.NET example pattern)
cmd.Parameters.Add("@id", SqlDbType.Int).Value = customerId;
```

```sql
-- Bad — never do this with user input
-- EXEC('SELECT * FROM Customer WHERE Id = ' + @userInput)
```

Use `sp_executesql` with parameters for dynamic SQL.

---

## Auditing

```sql
CREATE SERVER AUDIT LearnSqlAudit
TO FILE (FILEPATH = N'D:\Audit\');

ALTER SERVER AUDIT LearnSqlAudit WITH (STATE = ON);

CREATE DATABASE AUDIT SPECIFICATION LearnDbAudit
FOR SERVER AUDIT LearnSqlAudit
ADD (SELECT, INSERT, UPDATE, DELETE ON dbo.Customer BY dbo);
```

Review audit logs for compliance and incident response.

---

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Shared sa password | Disable or restrict; per-app logins |
| `db_owner` for every app | Custom roles with minimal grants |
| SQL auth without encryption | Force TLS / Encrypt connection |

## Production security checklist

- [ ] Disable `sa` or restrict; no shared sa password
- [ ] Mixed mode only if required; enforce password policy
- [ ] Separate accounts for app, admin, reporting
- [ ] Firewall: only app subnets to port 1433
- [ ] Patch SQL Server regularly
- [ ] Encrypt backups; restrict backup folder ACLs
- [ ] Document break-glass admin procedure

**Script:** [sql/08-security-setup.sql](../sql/08-security-setup.sql)

---

## Next

[06-production-operations.md](06-production-operations.md)
