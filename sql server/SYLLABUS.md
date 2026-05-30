# SQL Server Management — Full Syllabus

**Track:** Developer + DBA | **Language:** English | **Duration:** 16 weeks (5–10 hrs/week)

Start: [README.md](README.md) | Checklist: [LEARNING-CHECKLIST.md](LEARNING-CHECKLIST.md) | Template: [docs/MODULE-TEMPLATE.md](docs/MODULE-TEMPLATE.md)

---

## Learning outcomes (course-level)

By the end you can:

1. Install and connect to SQL Server using SSMS  
2. Design schemas (ERD, normalization) and implement with T-SQL  
3. Build views, procedures, transactions for applications  
4. Tune queries using indexes, plans, and Query Store  
5. Administer backups, security, monitoring, and basic HA concepts  
6. Document production runbooks and troubleshoot common issues  

---

## Part I — Foundations (Weeks 1–3)

| Module | Title | Doc | SQL | Exercises |
|--------|-------|-----|-----|-----------|
| 00 | Install & Editions | [part-01/00-install-setup.md](docs/part-01-foundations/00-install-setup.md) | [00-verify-instance.sql](sql/00-verify-instance.sql) | [module-00](exercises/module-00.md) |
| 01 | SSMS & First Queries | [01-getting-started-ssms.md](docs/01-getting-started-ssms.md) | 01 | [module-01](exercises/module-01.md) |
| 02 | T-SQL Fundamentals | [02-sql-fundamentals.md](docs/02-sql-fundamentals.md) | 02–04 | [module-02](exercises/module-02.md) |
| 03 | Data Modeling & ERD | [part-01/03-data-modeling.md](docs/part-01-foundations/03-data-modeling.md) | 11, 16 | [module-03](exercises/module-03.md) |

---

## Part II — Developer (Weeks 4–7)

| Module | Title | Doc | SQL | Exercises |
|--------|-------|-----|-----|-----------|
| 04 | Advanced T-SQL | [04-advanced-developer.md](docs/04-advanced-developer.md) | 05–07, 13 | [module-04](exercises/module-04.md) |
| 05 | Indexes & Query Tuning | [09-performance-scalability.md](docs/09-performance-scalability.md), [10-time-complexity-queries.md](docs/10-time-complexity-queries.md) | 10, 17, [24-query-store.sql](sql/24-query-store.sql) | [module-05](exercises/module-05.md) |
| 06 | App Integration | [part-02/06-app-integration.md](docs/part-02-developer/06-app-integration.md) | [21-app-patterns-samples.sql](sql/21-app-patterns-samples.sql) | [module-06](exercises/module-06.md) |

---

## Part III — DBA (Weeks 5–9)

| Module | Title | Doc | SQL | Exercises |
|--------|-------|-----|-----|-----------|
| 07 | Instance & Storage | [03-server-management.md](docs/03-server-management.md) | 12, [22-tempdb-instance-config.sql](sql/22-tempdb-instance-config.sql) | [module-07](exercises/module-07.md) |
| 08 | Backup, Restore & DR | [06-production-operations.md](docs/06-production-operations.md), [12-production-runbook-template.md](docs/12-production-runbook-template.md) | 09, 12, 15, [25-restore-drill](sql/25-restore-drill-template.sql) | [module-08](exercises/module-08.md) |
| 09 | Security & Compliance | [05-security.md](docs/05-security.md) | 08, 14 | [module-09](exercises/module-09.md) |
| 10 | Monitoring & Troubleshooting | [part-03/10-monitoring.md](docs/part-03-dba/10-monitoring.md) | [19-extended-events-lab.sql](sql/19-extended-events-lab.sql) | [module-10](exercises/module-10.md) |

---

## Part IV — Advanced Production (Weeks 10–14)

| Module | Title | Doc | SQL | Exercises |
|--------|-------|-----|-----|-----------|
| 11 | HA & Scale-Out | [part-04/11-high-availability.md](docs/part-04-advanced/11-high-availability.md) | [23-ha-concepts-readonly.sql](sql/23-ha-concepts-readonly.sql) | [module-11](exercises/module-11.md) |
| 12 | Automation & Agent | [part-04/12-automation.md](docs/part-04-advanced/12-automation.md) | [20-agent-job-lab.sql](sql/20-agent-job-lab.sql) | [module-12](exercises/module-12.md) |
| 13 | Azure & Hybrid | [part-04/13-azure-hybrid.md](docs/part-04-advanced/13-azure-hybrid.md) | — | [module-13](exercises/module-13.md) |
| 14 | Capstone Projects | [14-capstone-projects.md](docs/part-04-advanced/14-capstone-projects.md) | 11, 18, [ecommerce-full.sql](sql/projects/ecommerce-full.sql) | [module-14](exercises/module-14.md), [CAPSTONE-CHECKLIST](CAPSTONE-CHECKLIST.md) |

---

## Appendices (reference)

| Appendix | File |
|----------|------|
| A | [appendices/A-dmv-reference.md](docs/appendices/A-dmv-reference.md) |
| B | [appendices/B-glossary.md](docs/appendices/B-glossary.md) |
| C | [appendices/C-troubleshooting.md](docs/appendices/C-troubleshooting.md) |
| D | [appendices/D-certification-map.md](docs/appendices/D-certification-map.md) |

---

## 16-week schedule

| Week | Modules | Hours |
|------|---------|-------|
| 1 | 00, 01 | 5–8 |
| 2 | 02 | 6–10 |
| 3 | 03 | 6–8 |
| 4 | 04 | 6–10 |
| 5 | 07, 08 (start DBA) | 6–10 |
| 6 | 05, 06 | 6–10 |
| 7 | 08 (finish), 09 | 6–10 |
| 8 | 10 | 5–8 |
| 9 | 11 | 5–8 |
| 10 | 12 | 5–8 |
| 11 | 13 | 4–6 |
| 12 | 14 Library | 6–10 |
| 13 | 14 School + E-commerce | 6–10 |
| 14 | Appendices + review | 5–8 |
| 15 | Capstone polish + restore drill | 6–10 |
| 16 | Mock interview / cert prep (App D) | 4–6 |

---

## Optional

- [14-bengali-summary.md](docs/14-bengali-summary.md) — Bengali overview (not required for English track)
