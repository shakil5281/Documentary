# 07 — SQL Server Instance & Operations (DBA)

> **Part:** III DBA | **Module ID:** 07 (legacy filename `03`) | **SQL:** [09](../sql/09-maintenance-production.sql), [12](../sql/12-module03-server-monitoring.sql), [22](../sql/22-tempdb-instance-config.sql) | **Exercises:** [module-07](../exercises/module-07.md)

## Learning outcomes

1. Explain system databases and recovery models  
2. Configure instance memory and TempDB basics  
3. Run backup and CHECKDB  
4. Use DMVs for sessions and blocking  

This guide covers how to **manage a SQL Server instance** like an advanced developer or junior DBA—not only writing queries.

---

## Architecture (mental model)

```
┌─────────────────────────────────────────┐
│           SQL Server INSTANCE            │
│  ┌─────────┐ ┌─────────┐ ┌───────────┐  │
│  │ DB: App │ │ DB: Log │ │ DB: Learn │  │
│  └─────────┘ └─────────┘ └───────────┘  │
│         Engine (storage, query, security) │
└─────────────────────────────────────────┘
         ▲                    ▲
    SSMS / Apps          Agent (jobs)
```

- **Instance** = one installed engine + system databases (`master`, `model`, `msdb`, `tempdb`).
- **User databases** = your application data.

---

## System databases (do not drop)

| Database | Role |
|----------|------|
| `master` | Instance metadata, logins info |
| `model` | Template for new databases |
| `msdb` | SQL Agent jobs, backup history |
| `tempdb` | Temporary objects, sorts, spills |

---

## Services (Windows)

Open **Services** (`services.msc`):

| Service | Purpose |
|---------|---------|
| SQL Server (`MSSQLSERVER` or named) | Core engine |
| SQL Server Agent | Scheduled jobs, alerts |
| SQL Server Browser | Helps clients find named instances |

**Start mode:** Automatic for production instances that must survive reboot.

---

## Configuration (high level)

In SSMS: **Object Explorer → right-click server → Properties**

| Area | What to know |
|------|----------------|
| **Memory** | Max server memory — leave RAM for OS and other apps |
| **Processors** | Max degree of parallelism (MAXDOP) — affects large queries |
| **Security** | Mixed mode vs Windows-only authentication |
| **Database settings** | Default paths for data/log files |

**Advanced:** `sp_configure` exposes many options; some need `RECONFIGURE`.

```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'max degree of parallelism';
```

---

## Database lifecycle

### Create

```sql
CREATE DATABASE LearnSQL
ON PRIMARY (
    NAME = N'LearnSQL_Data',
    FILENAME = N'C:\SQLData\LearnSQL.mdf',
    SIZE = 100MB,
    FILEGROWTH = 50MB
)
LOG ON (
    NAME = N'LearnSQL_Log',
    FILENAME = N'C:\SQLLogs\LearnSQL.ldf',
    SIZE = 50MB,
    FILEGROWTH = 25MB
);
```

Use explicit paths in production; default paths vary by install.

### Alter size / options

```sql
ALTER DATABASE LearnSQL SET RECOVERY FULL;  -- point-in-time restore possible
ALTER DATABASE LearnSQL SET AUTO_UPDATE_STATISTICS ON;
```

### Recovery models

| Model | Log behavior | Use case |
|-------|--------------|----------|
| **SIMPLE** | Log truncated automatically | Dev, replaceable data |
| **FULL** | Log backups required | Production OLTP |
| **BULK_LOGGED** | Minimal log for bulk ops | Special bulk loads |

---

## Backup and restore (essential)

```sql
BACKUP DATABASE LearnSQL
TO DISK = N'D:\Backup\LearnSQL_full.bak'
WITH COMPRESSION, CHECKSUM, STATS = 10;

BACKUP LOG LearnSQL
TO DISK = N'D:\Backup\LearnSQL_log.trn';
```

```sql
RESTORE DATABASE LearnSQL_Dev
FROM DISK = N'D:\Backup\LearnSQL_full.bak'
WITH MOVE N'LearnSQL_Data' TO N'C:\SQLData\LearnSQL_Dev.mdf',
     REPLACE, RECOVERY;
```

**Script:** [sql/09-maintenance-production.sql](../sql/09-maintenance-production.sql)

---

## Monitoring health

### Quick checks

```sql
-- Active sessions
SELECT session_id, login_name, status, cpu_time, memory_usage
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

-- Blocking chain (simplified)
SELECT blocking_session_id, session_id, wait_type, wait_time
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
```

### SSMS reports

Right-click database → **Reports** → Standard Reports (disk usage, top queries).

### Extended events / Profiler

Use **Extended Events** (modern) instead of SQL Profiler for capturing slow queries.

---

## SQL Server Agent (jobs)

Automate:

- Nightly full backup
- Index maintenance
- ETL steps

Create in SSMS: **SQL Server Agent → Jobs → New Job** (steps, schedule, notifications).

---

## High availability (overview)

| Technology | Idea |
|------------|------|
| **Always On AG** | Multiple replicas, automatic failover |
| **Log shipping** | Restore log backups to standby |
| **Failover Cluster** | Shared storage, one active node |

Production teams document **RPO** (how much data you can lose) and **RTO** (how fast you must be back).

---

## Maintenance checklist (monthly)

- [ ] Verify backups restore to test server
- [ ] Review disk space (data + log + backup volume)
- [ ] Check failed Agent jobs
- [ ] Review top wait stats and slow queries
- [ ] Update statistics / index maintenance per policy
- [ ] Patch SQL Server on a schedule

---

## TempDB and instance config

Hands-on: [sql/22-tempdb-instance-config.sql](../sql/22-tempdb-instance-config.sql)

- Multiple **equal-sized** TempDB data files reduce allocation contention  
- Set **max server memory** so OS and other apps retain RAM  

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Single small TempDB file on busy system | Add files; pre-grow |
| No backup chain in FULL model | Schedule log backups |
| Ignoring blocking | Use `sys.dm_exec_requests` (module 10) |

## Practice exercises

[exercises/module-07.md](../exercises/module-07.md)

1. List all databases and their recovery model (`sys.databases`).
2. Take a backup of `LearnSQL` to a folder you create.
3. Find your server’s `max server memory (MB)` in Server Properties.
4. Identify one running session and its current query text (`sys.dm_exec_sql_text`).

---

## Next

[04-advanced-developer.md](04-advanced-developer.md)
