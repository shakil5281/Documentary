# Production Runbook Template (Fill In for Real Projects)

Copy this file per application/database and complete with your team.

---

## 1. System overview

| Field | Value |
|-------|-------|
| Application name | |
| Database name(s) | |
| SQL Server instance | |
| Environment | DEV / TEST / STAGING / **PROD** |
| Owner team | |
| On-call contact | |

---

## 2. Recovery objectives

| Metric | Target | Notes |
|--------|--------|-------|
| **RPO** (max data loss) | e.g. 15 minutes | Drives log backup frequency |
| **RTO** (max downtime) | e.g. 1 hour | Drives HA design |

---

## 3. Backup schedule

| Type | Frequency | Retention | Location |
|------|-----------|-----------|----------|
| Full | | | |
| Differential | | | |
| Log | | | |

**Last restore test date:** ___________  
**Restore tested by:** ___________

---

## 4. Maintenance windows

| Task | Schedule | Script/job name |
|------|----------|-----------------|
| CHECKDB | | |
| Index rebuild/reorganize | | |
| Update statistics | | |

---

## 5. Security

| Item | Status |
|------|--------|
| sa disabled or locked | |
| App uses dedicated login(s) | |
| No passwords in connection strings in git | |
| TLS enforced | |
| Auditing enabled | |

---

## 6. Incident steps (short)

1. Check AG/cluster dashboard / SQL connectivity  
2. Identify blocking: `sys.dm_exec_requests`  
3. Recent deploy? Rollback app or DB migration  
4. Failover only per approved runbook  
5. Post-incident: timeline + action items  

---

## 7. Change deployment

| Step | Owner |
|------|-------|
| Script reviewed in PR | |
| Applied to QA | |
| Applied to Staging | |
| Production change ticket | |
| Rollback script ready | |

---

## 8. Key queries (paste your versions)

```sql
-- Active blocking
SELECT * FROM sys.dm_exec_requests WHERE blocking_session_id <> 0;

-- DB size
EXEC sp_spaceused;

-- Last backup
SELECT TOP 5 database_name, type, backup_finish_date
FROM msdb.dbo.backupset
WHERE database_name = N'YourDb'
ORDER BY backup_finish_date DESC;
```
