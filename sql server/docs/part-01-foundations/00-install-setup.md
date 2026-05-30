# 00 — Install SQL Server & Editions

> **Part:** I Foundations | **SQL:** [sql/00-verify-instance.sql](../../sql/00-verify-instance.sql) | **Exercises:** [module-00](../../exercises/module-00.md)

## Learning outcomes

1. Choose an appropriate SQL Server edition for learning  
2. Install Developer or Express and SSMS  
3. Connect to the instance and verify version  
4. Understand instance vs database vs schema  

## Editions (summary)

| Edition | Use |
|---------|-----|
| **Developer** | Full features; free; dev/test only |
| **Express** | Free; size/CPU limits; small apps |
| **Standard / Enterprise** | Production licensing |

## Install steps (Windows)

1. Download [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) → Developer  
2. Run installer → **Database Engine Services**  
3. Instance: default `MSSQLSERVER` or named `SQLEXPRESS`  
4. Authentication: **Mixed Mode** if you need SQL logins (learning security module)  
5. Install [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) separately  

## SSMS walkthrough — first connect

| Step | Action |
|------|--------|
| 1 | Open SSMS → Server type: Database Engine |
| 2 | Server name: `.` or `localhost\SQLEXPRESS` or `(localdb)\MSSQLLocalDB` |
| 3 | Authentication: Windows Authentication (simplest) |
| 4 | Connect → expand server node |

## Verify install

Run [sql/00-verify-instance.sql](../../sql/00-verify-instance.sql):

```sql
SELECT @@VERSION AS Version, @@SERVERNAME AS ServerName, DB_NAME() AS CurrentDb;
```

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Wrong server name | Check Services for `SQL Server (INSTANCE)` |
| Cannot connect remotely | Enable TCP, firewall port 1433, SQL Browser for named instances |
| Using Developer in production | Violates license; use Standard/Enterprise |

## Network (optional)

- Default port **1433** for default instance  
- Named instances may need **SQL Server Browser** UDP 1434  

## Exercises

[exercises/module-00.md](../../exercises/module-00.md)

## Further reading

- [Install SQL Server](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server)

## Next

[01 — SSMS](../01-getting-started-ssms.md)
