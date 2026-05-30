# SQL Server Quick Reference (PDF-ready)

One-page style cheat sheet for daily work. Full lessons: [SYLLABUS.md](SYLLABUS.md).

---

## Connect

```
Server=localhost;Database=LearnSQL;Trusted_Connection=True;TrustServerCertificate=True;
```

## Essential commands

```sql
SELECT @@VERSION, @@SERVERNAME, DB_NAME();
USE LearnSQL;
GO
```

## DDL

```sql
CREATE TABLE dbo.T (Id INT PRIMARY KEY, Name NVARCHAR(100) NOT NULL);
ALTER TABLE dbo.T ADD Col INT NULL;
CREATE INDEX IX_T_Col ON dbo.T(Col);
```

## DML

```sql
SELECT cols FROM dbo.T WHERE id = 1;
INSERT INTO dbo.T (Name) VALUES (N'x');
UPDATE dbo.T SET Name = N'y' WHERE Id = 1;
DELETE FROM dbo.T WHERE Id = 1;  -- always WHERE in prod
```

## JOINs

```sql
FROM a INNER JOIN b ON b.Aid = a.Id
FROM a LEFT JOIN b ON b.Aid = a.Id WHERE b.Id IS NULL  -- no match
```

## Backup / restore

```sql
BACKUP DATABASE LearnSQL TO DISK = N'C:\Temp\SqlBackups\learn.bak' WITH COMPRESSION, CHECKSUM;
RESTORE DATABASE LearnSQL_Test FROM DISK = N'...\learn.bak' WITH REPLACE, RECOVERY;
DBCC CHECKDB (LearnSQL);
```

## Security

```sql
CREATE LOGIN x WITH PASSWORD = '...';
CREATE USER x FOR LOGIN x;
GRANT SELECT ON dbo.Customer TO x;
```

## Monitoring

```sql
SELECT * FROM sys.dm_exec_requests WHERE blocking_session_id <> 0;
SELECT TOP 10 wait_type, wait_time_ms FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE 'SLEEP%' ORDER BY wait_time_ms DESC;
```

## Performance rules

| Do | Avoid |
|----|--------|
| `WHERE Col >= @d1 AND Col < @d2` | `WHERE YEAR(Col)=2026` |
| Keyset: `WHERE Id > @last` | Deep `OFFSET` |
| Covering index `INCLUDE (...)` | Too many indexes |

## Recovery models

| Model | Use |
|-------|-----|
| SIMPLE | Dev |
| FULL | Production OLTP |

## System DBs

`master`, `model`, `msdb`, `tempdb`

## RPO / RTO

- **RPO** — max data loss → log backup frequency  
- **RTO** — max downtime → HA / restore speed  

## Doc index

[DOC-INDEX.md](DOC-INDEX.md) | [Appendix A DMVs](docs/appendices/A-dmv-reference.md) | [Appendix C Troubleshooting](docs/appendices/C-troubleshooting.md)
