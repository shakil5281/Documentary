# 06 — Application Integration Patterns

> **Part:** II Developer | **SQL:** [21-app-patterns-samples.sql](../../sql/21-app-patterns-samples.sql) | **Exercises:** [module-06](../../exercises/module-06.md)

## Learning outcomes

1. Build correct connection strings for SQL Server  
2. Explain connection pooling and why it matters  
3. Choose transaction isolation for app workloads  
4. Version schema with migration scripts  

## Connection strings

```
Server=localhost;Database=LearnSQL;Trusted_Connection=True;TrustServerCertificate=True;
```

SQL auth (dev only):

```
Server=localhost;Database=LearnSQL;User Id=AppUser;Password=***;Encrypt=True;
```

**Never** embed `sa` or production passwords in source control.

## Pooling

- ADO.NET / JDBC / ODBC pools connections by default  
- Open late, close/dispose promptly (or use `using`)  
- Many short connections still cost CPU — pool reuse helps  

## Isolation for apps

| Level | App use |
|-------|---------|
| READ COMMITTED | Default; most OLTP |
| READ UNCOMMITTED | Avoid (dirty reads) |
| SNAPSHOT | Reporting without blocking writers (needs DB setting) |
| SERIALIZABLE | Rare; high blocking |

Demo: [sql/21-app-patterns-samples.sql](../../sql/21-app-patterns-samples.sql)

## ORM notes (EF Core / Dapper)

- EF generates SQL — review plans for hot paths  
- Dapper: parameterized queries manually  
- Migrations: one script per release; idempotent where possible  

## Schema migrations

```
/Versions
  001_Initial.sql
  002_AddCustomerPhone.sql
```

- Apply in order on CI → QA → Prod  
- Keep rollback script for risky changes  

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Dynamic SQL from user input | Parameters only |
| Long open transactions | Commit quickly |
| MARS + legacy drivers | Test connection flags |

## Exercises

[exercises/module-06.md](../../exercises/module-06.md)

## Further reading

- [Connection strings](https://learn.microsoft.com/en-us/sql/connect/ado-net/connection-string-syntax)

## Next

[07 — Instance management](../03-server-management.md)
