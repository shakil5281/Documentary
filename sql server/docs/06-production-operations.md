# 08 — Production Operations & DR

> **Part:** III DBA | **Module ID:** 08 (legacy filename `06`) | **SQL:** [09](../sql/09-maintenance-production.sql), [15](../sql/15-module06-production-lab.sql) | **Runbook:** [12-production-runbook-template.md](12-production-runbook-template.md) | **Exercises:** [module-08](../exercises/module-08.md)

## Learning outcomes

1. Promote changes across Dev/Test/Prod  
2. Define RPO/RTO and backup strategy  
3. Run restore drills and CHECKDB  
4. Use production readiness checklist  

Production means **users depend on the database 24/7**. Your job: keep it **available**, **correct**, **fast**, and **recoverable**.

---

## Environments

| Environment | Purpose |
|-------------|---------|
| **Dev** | Experiment; can break |
| **Test/QA** | Validate releases |
| **Staging** | Production-like load/config |
| **Production** | Live data; strict change control |

**Never** learn on production. Promote scripts via CI/CD or reviewed change tickets.

---

## Deployment pipeline (typical)

```
Developer writes migration SQL
    → Peer review
    → Apply to QA
    → Automated tests
    → Staging soak
    → Production window (with rollback plan)
```

Tools: SSDT (dacpac), Flyway, Liquibase, Azure DevOps.

---

## Change management

- Version every schema change
- Backward-compatible phases when possible (add column → deploy app → remove old)
- **Rollback script** for every production change
- Maintenance windows for risky operations (index rebuilds on huge tables)

---

## Backup strategy (FULL recovery)

| Backup type | Frequency | Purpose |
|-------------|-----------|---------|
| **Full** | Weekly (or daily) | Base restore point |
| **Differential** | Daily | Faster restore since last full |
| **Log** | Every 15–60 min | Point-in-time recovery |

Verify: **restore drill** monthly to unused server.

---

## Disaster recovery

Document:

- RPO / RTO targets
- Failover steps (AG, cluster, cloud geo-replica)
- Who approves failover
- Communication plan

---

## Capacity planning

Monitor growth:

```sql
SELECT DB_NAME(database_id) AS DbName,
       SUM(size * 8 / 1024) AS SizeMB
FROM sys.master_files
GROUP BY database_id;
```

Plan disk **before** 80% full; log file autogrowth storms hurt performance.

---

## Index and statistics maintenance

- **Rebuild** heavily fragmented indexes (off-peak)
- **Reorganize** light fragmentation
- **UPDATE STATISTICS** after large data changes

Use Ola Hallengren’s maintenance scripts industry-wide, or Agent jobs.

---

## Alerting

Alert on:

- Failed backups / Agent jobs
- Disk space low
- Blocking > N minutes
- AG not synchronized
- CPU/memory sustained high

Integrate: email, PagerDuty, Teams, SCOM, Azure Monitor.

---

## Compliance and data retention

- PII handling (GDPR, local laws)
- Retention policies (archive, purge)
- Immutable audit trails where required

---

## Incident response (simplified)

1. **Detect** — alert or user report
2. **Mitigate** — kill rogue session, failover, throttle app
3. **Diagnose** — plans, waits, recent deploys
4. **Fix** — patch, rollback, hotfix
5. **Post-mortem** — blameless, action items

---

## Production readiness lab

Run [sql/15-module06-production-lab.sql](../sql/15-module06-production-lab.sql) — review PASS/WARN/FAIL report.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Backups never restored | Monthly restore drill |
| Deploy straight to prod | Dev → Test → Staging → Prod |
| No runbook | Use [12-production-runbook-template.md](12-production-runbook-template.md) |

## Production checklist (launch day)

- [ ] Backups automated and tested restore
- [ ] Monitoring and on-call rotation
- [ ] Runbook for failover
- [ ] Least-privilege service accounts
- [ ] Resource limits (MAXDOP, memory, TempDB files)
- [ ] Documentation: schema, owners, SLAs

**Scripts:** [sql/09-maintenance-production.sql](../sql/09-maintenance-production.sql), [sql/25-restore-drill-template.sql](../sql/25-restore-drill-template.sql)

---

## Next

[07-database-design-erd.md](07-database-design-erd.md)
