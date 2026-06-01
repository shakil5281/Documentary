# Microservices Architecture — Web View

## Interactive documentation viewer (recommended)

Open the **full tabbed viewer** with in-page preview for every `.md` file:

### Step 1 — Start local server

```powershell
cd "c:\Users\shaki\Desktop\SHAKIL\learn\microservices architecture"
.\web\serve.ps1
```

Or double-click `web\serve.bat`, or run `python -m http.server 8080` from the project root.

### Step 2 — Open in browser

**http://localhost:8080/web/index.html**

---

## Viewer features

| Feature | Description |
|---------|-------------|
| **Tabs** | Dashboard · Full grid · Part I–IV · Docs · Exercises · Solutions · Appendices |
| **Full grid** | Card for every file (94) — click to open |
| **Sidebar** | Filtered file list per tab |
| **Preview** | Markdown rendered with syntax highlighting |
| **Search** | Filter grid and sidebar |
| **Curriculum table** | Modules 00–21 with doc + exercise + solution links |

---

## Files

| File | Role |
|------|------|
| [web/index.html](web/index.html) | Main web UI |
| [web/files-manifest.json](web/files-manifest.json) | Index of all docs |
| [web/serve.ps1](web/serve.ps1) | Local server launcher |

After adding new lessons, run:

```powershell
.\web\rebuild-all.ps1
```

---

## Offline mode (no server)

The viewer includes **`web/content-bundle.js`** (~143 KB) with all docs embedded.  
Open `web/index.html` via a local server or after running `rebuild-all.ps1` — badge shows **offline bundle**.

Regenerate after edits:

```powershell
.\web\rebuild-all.ps1
```

Includes `manifest-bundle.js` (required for **Part I–IV** tabs offline).

## Why a server is still useful

A local server loads **live** files from disk (badge: **live server**) so you see changes without regenerating the bundle.

---

See also: [SYLLABUS.md](SYLLABUS.md) · [QUICK-REFERENCE.md](QUICK-REFERENCE.md) · [DOC-INDEX.md](DOC-INDEX.md)
