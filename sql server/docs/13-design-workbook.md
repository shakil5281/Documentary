# Design Workbook — Modules 7 & 8 (ERD + Data Flow)

Complete this workbook once per project. Use **HospitalDB** and **LibraryDB** from your labs.

---

## Part A — ERD (Module 7)

### A1. HospitalDB (3 tables + junction)

Draw an ERD with:

- **Patient** 1 — N **Appointment** N — 1 **Doctor**
- Cardinality labels on every line
- PK and FK marked

**Checklist:**

- [ ] Every M:N split into a junction table (`Appointment`)
- [ ] No repeating groups (multiple doctors in one Patient row = bad)
- [ ] Surrogate keys (`PatientId`) + natural unique (`NationalId`)

### A2. LibraryDB (from capstone)

Open `docs/11-capstone-library-project.md` — redraw ERD from memory, then compare.

### A3. Normalization drill

**Unnormalized (bad):**

| OrderId | CustomerName | CustomerCity | ProductName |
|---------|--------------|--------------|-------------|
| 1 | Alice | Dhaka | Laptop |

**Questions:**

1. What normal form is violated? (hint: CustomerCity depends on CustomerName, not OrderId)  
2. Split into `Customer`, `Order`, `OrderLine` / `Product` — sketch tables.

---

## Part B — Data flow (Module 8)

### B1. Library — Context diagram (level 0)

Draw one diagram:

- External entities: **Member**, **Librarian**
- One process: **Library System**
- Flows: loan request, return, catalog update

### B2. Library — Level 1

Minimum processes:

| ID | Process |
|----|---------|
| 1.0 | Register member |
| 2.0 | Issue loan |
| 3.0 | Return book |
| D1 | LibraryDB |

Show arrows between entities, processes, and **D1**.

### B3. Map to SQL Server

| DFD element | SQL Server artifact |
|-------------|---------------------|
| D1 LibraryDB | Database `LibraryDB` |
| 2.0 Issue loan | `library.usp_IssueLoan` |
| 3.0 Return book | `library.usp_ReturnLoan` |
| Reports | Views e.g. `library.vw_ActiveLoans` |

---

## Part C — Scalability notes (link to Module 9)

For Library system at **100× users**, list:

1. One **read** bottleneck → fix (e.g. read replica, cache book catalog)  
2. One **write** bottleneck → fix (e.g. queue returns, partition loans by year)  
3. One **index** you would add (already have `IX_Loan_DueDate` — explain why)

---

## Submission (for yourself)

- [ ] Photo or PNG of Hospital ERD  
- [ ] PNG of Library context + level 1 DFD  
- [ ] Answers to A3 normalization  
- [ ] Part C three bullets  

Then check **Modules 7 & 8** on `LEARNING-CHECKLIST.md`.
