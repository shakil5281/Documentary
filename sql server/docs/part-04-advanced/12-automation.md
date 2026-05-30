# 12 — Automation (SQL Agent & Scripts)

> **Part:** IV Advanced | **SQL:** [20-agent-job-lab.sql](../../sql/20-agent-job-lab.sql) | **Exercises:** [module-12](../../exercises/module-12.md)

## Learning outcomes

1. Create SQL Server Agent jobs, steps, and schedules  
2. Describe maintenance solution patterns (index/stats backups)  
3. Run a simple PowerShell backup invocation  
4. Write idempotent deployment scripts  

## SQL Server Agent

Requires **SQL Server Agent** service running (not on Express in older versions; check your edition).

Components:

| Object | Role |
|--------|------|
| Job | Container |
| Step | T-SQL, PowerShell, CmdExec, SSIS |
| Schedule | Cron-like timing |
| Alert | Response to error/performance condition |

## SSMS walkthrough

| Step | Action |
|------|--------|
| 1 | SQL Server Agent → Jobs → New Job |
| 2 | Steps → New → T-SQL: `EXEC msdb.dbo.sp_start_job` test |
| 3 | Schedules → daily 2 AM |
| 4 | History → verify outcome |

Lab script: [sql/20-agent-job-lab.sql](../../sql/20-agent-job-lab.sql)

## Maintenance

Industry pattern: [Ola Hallengren](https://ola.hallengren.com/) scripts for IndexOptimize and DatabaseBackup — review before production use.

## PowerShell example (concept)

```powershell
Backup-SqlDatabase -ServerInstance "localhost" -Database "LearnSQL" `
  -BackupAction Database -BackupFile "C:\Temp\SqlBackups\learn.bak"
```

Requires **SqlServer** PowerShell module.

## Idempotent migrations

```sql
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'Phone' AND object_id = OBJECT_ID(N'dbo.Customer'))
    ALTER TABLE dbo.Customer ADD Phone NVARCHAR(30) NULL;
```

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Job owner lacks permissions | Use proxy or correct job owner |
| No failure notification | Configure Database Mail / operators |
| Long jobs without timeout | Set reasonable command timeout |

## Next

[13 — Azure & hybrid](13-azure-hybrid.md)
