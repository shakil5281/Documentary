# Module 01 Solutions

```sql
SELECT name FROM sys.databases WHERE database_id > 4 OR name = N'LearnSQL';
USE LearnSQL;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
```

3. Results appear as text rows instead of grid.
4. `GO` sends the current batch to the server; not T-SQL executed like `SELECT`.
