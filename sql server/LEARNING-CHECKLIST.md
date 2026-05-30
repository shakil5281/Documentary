# Learning Checklist — Full Curriculum (Modules 00–14)

Use with [SYLLABUS.md](SYLLABUS.md). Check when you can do each item **without looking at solutions**.

---

## Part I — Foundations

### Module 00 — Install & editions
- [ ] Install SQL Server Developer or Express
- [ ] Connect with SSMS (Windows or SQL auth)
- [ ] Run `sql/00-verify-instance.sql` successfully

### Module 01 — SSMS
- [ ] Run `SELECT @@VERSION` and read Results/Messages
- [ ] Navigate Object Explorer
- [ ] Save and reopen a `.sql` script

### Module 02 — T-SQL fundamentals
- [ ] Explain DDL vs DML vs DCL
- [ ] Create table with PK, FK, UNIQUE, CHECK
- [ ] Safe INSERT, UPDATE, DELETE with `WHERE`
- [ ] INNER and LEFT JOIN; write a CTE

### Module 03 — Data modeling
- [ ] Draw ERD with 1:N and M:N (junction table)
- [ ] Explain 3NF in your own words
- [ ] Draw context + Level 1 DFD
- [ ] Complete [docs/13-design-workbook.md](docs/13-design-workbook.md)

---

## Part II — Developer

### Module 04 — Advanced T-SQL
- [ ] Create procedure with parameters
- [ ] Create view; explain trigger trade-offs
- [ ] TRY/CATCH with transaction rollback

### Module 05 — Indexes & tuning
- [ ] Read execution plan (seek vs scan)
- [ ] Create covering nonclustered index
- [ ] Rewrite non-sargable predicate
- [ ] Enable and query Query Store

### Module 06 — App integration
- [ ] Explain connection pooling
- [ ] Name default isolation level and one alternative
- [ ] Parameterize queries (anti-injection)

---

## Part III — DBA

### Module 07 — Instance & storage
- [ ] Name four system databases
- [ ] Explain TempDB purpose
- [ ] Check `max server memory` in SSMS

### Module 08 — Backup & DR
- [ ] FULL vs SIMPLE recovery
- [ ] Successful `BACKUP DATABASE` to disk
- [ ] Restore drill to test database
- [ ] Fill [docs/12-production-runbook-template.md](docs/12-production-runbook-template.md)

### Module 09 — Security
- [ ] Login vs database user vs role
- [ ] Create least-privilege reader
- [ ] List three production security rules

### Module 10 — Monitoring
- [ ] Find blocking with DMVs
- [ ] Read top wait stats
- [ ] Create one Extended Events session (lab)

---

## Part IV — Advanced

### Module 11 — HA & scale
- [ ] Explain Always On AG in one paragraph
- [ ] Name RPO/RTO for a sample app

### Module 12 — Automation
- [ ] Create SQL Agent job with one step (lab)
- [ ] Describe idempotent migration scripts

### Module 13 — Azure & hybrid
- [ ] Compare Azure SQL Database vs VM vs Managed Instance

### Module 14 — Capstones
- [ ] **LibraryDB** — backup + security role
- [ ] **SchoolDB** — 5 exercises in doc 15
- [ ] **EcommerceDB** — ERD + one tuned query
- [ ] Production readiness script 15 passes (no FAIL)

---

## Appendices (reference familiarity)
- [ ] Used [A-dmv-reference](docs/appendices/A-dmv-reference.md) during a slow query
- [ ] Used [C-troubleshooting](docs/appendices/C-troubleshooting.md) for blocking or disk

---

**Target:** 16 weeks at 5–10 hours/week | **Done:** [COURSE-COMPLETE.md](COURSE-COMPLETE.md)
