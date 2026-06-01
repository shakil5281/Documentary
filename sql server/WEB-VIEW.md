# SQL Server Learning — Web View

## Interactive documentation viewer (recommended)

Open the **full tabbed viewer** with in-page preview for every `.md` and `.sql` file:

### Step 1 — Start local server

```powershell
cd "c:\Users\shaki\Desktop\SHAKIL\learn\sql server"
.\web\serve.ps1
```

Or: `python -m http.server 8080` from the project root.

### Step 2 — Open in browser

**http://localhost:8080/web/index.html**

---

## Viewer features

| Feature | Description |
|---------|-------------|
| **Tabs** | Dashboard · Full grid · Part I–IV · Docs · SQL · Exercises · Solutions |
| **Full grid** | Card for every file (108+) — click to open |
| **Sidebar** | Filtered file list per tab |
| **Preview** | Markdown rendered + SQL syntax highlighting |
| **Search** | Filter grid and sidebar |
| **Curriculum table** | Modules 00–14 with doc + SQL links |

---

## Files

| File | Role |
|------|------|
| [web/index.html](web/index.html) | Main web UI |
| [web/files-manifest.json](web/files-manifest.json) | Index of all docs/SQL |
| [web/serve.ps1](web/serve.ps1) | Local server launcher |
| [sql/web-demo-queries.sql](sql/web-demo-queries.sql) | Demo queries |

After adding new lessons, run `.\web\generate-manifest.ps1` to refresh the grid.

---

## Offline mode (no server)

The viewer includes **`web/content-bundle.js`** (~240 KB) with all docs/SQL embedded.  
You can open `web/index.html` directly — files should load with badge **offline bundle**.

Regenerate after edits:

```powershell
.\web\rebuild-all.ps1
```

Includes `manifest-bundle.js` (required for **Part I–IV** tabs offline).

## Why a server is still useful

A local server loads **live** files from disk (badge: **live server**) so you see changes without regenerating the bundle.

---

## Markdown-only hub

This page lists links without preview. Use the **web viewer** above for the full experience.

See also: [SYLLABUS.md](SYLLABUS.md) · [QUICK-REFERENCE.md](QUICK-REFERENCE.md) · [DOC-INDEX.md](DOC-INDEX.md)
