# Module 09 Solutions

```sql
CREATE LOGIN ReportUser WITH PASSWORD = '...';
USE LearnSQL; CREATE USER ReportUser FOR LOGIN ReportUser;
GRANT SELECT ON dbo.Customer TO ReportUser;
```

2. DENY blocks even if role would allow; DENY wins.
3. `EXECUTE AS USER='Learn_AppReader'; DELETE ...` → permission denied; `REVERT;`
4. No sa for apps; TLS; least privilege; patch; audit; secret management.
