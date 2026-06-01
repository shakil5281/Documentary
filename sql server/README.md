# SQL Server Management — Complete Documentation

English curriculum from **install** through **advanced developer + DBA** topics. Theory, SSMS labs, exercises with solutions, and capstone projects.

**Finished the course?** [POST-NEXT-STEPS.md](POST-NEXT-STEPS.md)

**Start here:** [SYLLABUS.md](SYLLABUS.md) | **Web view:** Open [web/index.html](web/index.html) (offline bundle) or run `.\web\serve.bat` → [http://localhost:8080/web/index.html](http://localhost:8080/web/index.html) · Verify: `.\web\verify.ps1` · [WEB-VIEW.md](WEB-VIEW.md) | **Track progress:** [LEARNING-CHECKLIST.md](LEARNING-CHECKLIST.md) | **Cheat sheet:** [QUICK-REFERENCE.md](QUICK-REFERENCE.md)

---

## Quick start

1. Install SQL Server Developer/Express + [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
2. Run [sql/00-verify-instance.sql](sql/00-verify-instance.sql) then [sql/01-create-sample-database.sql](sql/01-create-sample-database.sql)
3. Follow [SYLLABUS.md](SYLLABUS.md) week 1 (modules 00–01)

---

## Documentation map

### Part I — Foundations

| Module | Document |
|--------|----------|
| 00 | [docs/part-01-foundations/00-install-setup.md](docs/part-01-foundations/00-install-setup.md) |
| 01 | [docs/01-getting-started-ssms.md](docs/01-getting-started-ssms.md) |
| 02 | [docs/02-sql-fundamentals.md](docs/02-sql-fundamentals.md) |
| 03 | [docs/part-01-foundations/03-data-modeling.md](docs/part-01-foundations/03-data-modeling.md) |

### Part II — Developer

| Module | Document |
|--------|----------|
| 04 | [docs/04-advanced-developer.md](docs/04-advanced-developer.md) |
| 05 | [docs/09-performance-scalability.md](docs/09-performance-scalability.md), [docs/10-time-complexity-queries.md](docs/10-time-complexity-queries.md) |
| 06 | [docs/part-02-developer/06-app-integration.md](docs/part-02-developer/06-app-integration.md) |

### Part III — DBA

| Module | Document |
|--------|----------|
| 07 | [docs/03-server-management.md](docs/03-server-management.md) |
| 08 | [docs/06-production-operations.md](docs/06-production-operations.md), [docs/12-production-runbook-template.md](docs/12-production-runbook-template.md) |
| 09 | [docs/05-security.md](docs/05-security.md) |
| 10 | [docs/part-03-dba/10-monitoring.md](docs/part-03-dba/10-monitoring.md) |

### Part IV — Advanced

| Module | Document |
|--------|----------|
| 11 | [docs/part-04-advanced/11-high-availability.md](docs/part-04-advanced/11-high-availability.md) |
| 12 | [docs/part-04-advanced/12-automation.md](docs/part-04-advanced/12-automation.md) |
| 13 | [docs/part-04-advanced/13-azure-hybrid.md](docs/part-04-advanced/13-azure-hybrid.md) |
| 14 | [docs/part-04-advanced/14-capstone-projects.md](docs/part-04-advanced/14-capstone-projects.md), [CAPSTONE-CHECKLIST.md](CAPSTONE-CHECKLIST.md) |

### Appendices

| Appendix | Document |
|----------|----------|
| A | [docs/appendices/A-dmv-reference.md](docs/appendices/A-dmv-reference.md) |
| B | [docs/appendices/B-glossary.md](docs/appendices/B-glossary.md) |
| C | [docs/appendices/C-troubleshooting.md](docs/appendices/C-troubleshooting.md) |
| D | [docs/appendices/D-certification-map.md](docs/appendices/D-certification-map.md) |

### Legacy / optional

| File | Note |
|------|------|
| [docs/07-database-design-erd.md](docs/07-database-design-erd.md) | Merged into module 03; kept for links |
| [docs/08-data-flow-architecture.md](docs/08-data-flow-architecture.md) | Merged into module 03 |
| [docs/13-design-workbook.md](docs/13-design-workbook.md) | Workbook for module 03 |
| [docs/14-bengali-summary.md](docs/14-bengali-summary.md) | Optional Bengali summary |
| [DOC-INDEX.md](DOC-INDEX.md) | Doc ↔ SQL cross-reference |
| [QUICK-REFERENCE.md](QUICK-REFERENCE.md) | One-page cheat sheet |
| [sql/README.md](sql/README.md) | All scripts with warnings |

---

## SQL scripts

| Range | Purpose |
|-------|---------|
| [00](sql/00-verify-instance.sql) | Instance verification |
| [01–04](sql/01-create-sample-database.sql) | LearnSQL core |
| [05–07, 13](sql/05-indexes-views.sql) | Advanced T-SQL |
| [08, 14](sql/08-security-setup.sql) | Security |
| [09, 12, 15, 25](sql/09-maintenance-production.sql) | Backup / production / restore drill |
| [10, 17, 24](sql/10-performance-tuning.sql) | Performance / Query Store |
| [11, 16, 18](sql/11-capstone-library-database.sql) | Capstones |
| [19–23](sql/19-extended-events-lab.sql) | Monitoring, Agent, HA |
| [21–22](sql/21-app-patterns-samples.sql) | App + instance config |
| [projects/ecommerce-full.sql](sql/projects/ecommerce-full.sql) | E-commerce capstone |

Module labs: `12`–`17` (guided labs from earlier curriculum).

---

## Exercises

Questions: [exercises/](exercises/) | Solutions: [exercises/solutions/](exercises/solutions/)

---

## Safety

- Dev machine only for learning scripts  
- Never use `sa` for applications  
- Backup before `DROP` / unqualified `DELETE`  

---

## Completion

[LEARNING-CHECKLIST.md](LEARNING-CHECKLIST.md) | [COURSE-COMPLETE.md](COURSE-COMPLETE.md) | [IMPLEMENTATION-STATUS.md](IMPLEMENTATION-STATUS.md)
