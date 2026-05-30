# 01 — Getting Started with SQL Server Management Studio (SSMS)

> **Part:** I Foundations | **Week:** 1 | **SQL:** [01-create-sample-database.sql](../sql/01-create-sample-database.sql) | **Exercises:** [module-01](../exercises/module-01.md) | **Solutions:** [solutions/module-01](../exercises/solutions/module-01.md)

## Learning outcomes

1. Connect to SQL Server with SSMS  
2. Run queries and read Results/Messages  
3. Navigate Object Explorer  
4. Switch database context with `USE`  

## What is SQL Server?

**Microsoft SQL Server** is a **relational database management system (RDBMS)**. It stores data in **tables** (rows and columns), enforces **rules** (constraints), and lets many applications read/write data safely at the same time.

## What is SSMS?

**SQL Server Management Studio (SSMS)** is the main **graphical tool** to:

- Connect to a server
- Write and run **T-SQL** queries
- Design tables (sometimes)
- Manage backups, security, jobs, and performance

You will use SSMS every day as a developer or DBA.

---

## Install (one-time)

1. Install **SQL Server** (Developer Edition is free for learning).
2. Install **SSMS** from Microsoft’s download page.
3. During setup, note your **instance name** (examples):
   - Default instance: `localhost` or `.`
   - Named instance: `localhost\SQLEXPRESS`
   - LocalDB: `(localdb)\MSSQLLocalDB`

---

## First connection

1. Open **SSMS**.
2. **Server type:** Database Engine  
3. **Server name:** your instance (see above)  
4. **Authentication:**
   - **Windows Authentication** — uses your Windows login (common on your PC).
   - **SQL Server Authentication** — username + password (common in apps and servers).

Click **Connect**.

### If connection fails

| Problem | Try |
|---------|-----|
| Server not found | Check SQL Server service is running (Services app → `SQL Server (...)`) |
| Named instance | Use `ComputerName\InstanceName` |
| Remote server | Firewall, TCP enabled, SQL Browser service |

---

## SSMS window tour (beginner map)

```
┌─────────────────────────────────────────────────────────────┐
│  Menu: File, Edit, Query, Tools                               │
├──────────────┬──────────────────────────────────────────────┤
│ Object       │  Query Editor (write SQL here)                 │
│ Explorer     │  ─────────────────────────────────────────── │
│              │  Results grid / Messages tab below             │
│  ▼ Server    │                                              │
│    ▼ DBs     │                                              │
│      ▼ Tables│                                              │
└──────────────┴──────────────────────────────────────────────┘
```

### Object Explorer (left)

- **Databases** — each database is a separate project of tables
- **Security** — logins, users, roles
- **Server Objects** — linked servers, endpoints
- **Management** — maintenance plans, Database Mail

### Query Editor (center)

- **New Query** — opens a blank `.sql` tab
- **Execute (F5)** — runs selected SQL or whole script
- **Parse (Ctrl+F5)** — checks syntax without running

### Results vs Messages

- **Results** — row sets from `SELECT`
- **Messages** — row counts, errors, `PRINT` output

---

## Your first queries

Open a **New Query** window. Run these one at a time:

```sql
-- What version am I connected to?
SELECT @@VERSION AS SqlVersion;

-- Which database am I using?
SELECT DB_NAME() AS CurrentDatabase;

-- List all databases on this server
SELECT name, database_id, create_date
FROM sys.databases
ORDER BY name;
```

**Explanation:**

- `SELECT` returns data.
- `@@VERSION` is a **system function** (built-in).
- `sys.databases` is a **catalog view** — metadata about databases.

---

## Switch database context

Every query runs **in the context of one database** (unless you use three-part names).

```sql
USE LearnSQL;  -- switch context (create this DB with sql/01 script)
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
```

`GO` is a **batch separator** for SSMS (not T-SQL executed by the engine the same way as `SELECT`).

---

## Good habits from day one

1. **Comment** your scripts (`--` single line, `/* */` multi-line).
2. **Format** SQL (right-click → Format Document, or install a formatter).
3. **Save** scripts in this repo under `sql/`.
4. Use **`USE database`** at the top so you never update the wrong DB.
5. In production: always have a **WHERE** on `UPDATE`/`DELETE` until you are sure.

---

## Keyboard shortcuts

| Shortcut | Action |
|----------|--------|
| F5 | Execute |
| Ctrl+R | Toggle Results pane |
| Ctrl+Space | IntelliSense (table/column names) |
| Ctrl+Shift+R | Refresh Object Explorer |

---

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Executing against wrong database | `USE LearnSQL;` at top of script |
| Confusing `GO` with T-SQL keyword | `GO` is a batch separator for SSMS only |
| Ignoring error in Messages tab | Read full error text; line number helps |

## Practice exercises

Full set: [exercises/module-01.md](../exercises/module-01.md)

1. Connect with Windows Authentication and run `SELECT @@VERSION`.
2. Expand **Databases** in Object Explorer — how many do you see?
3. Create a query that lists tables in `master` using `INFORMATION_SCHEMA.TABLES`.
4. Change the result to **Text** (Query menu → Results To → Results to Text) and compare with grid view.

---

## Next

- Run **[sql/01-create-sample-database.sql](../sql/01-create-sample-database.sql)**
- Read **[02-sql-fundamentals.md](02-sql-fundamentals.md)**
