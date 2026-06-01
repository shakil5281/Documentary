# Implementation Status

Last verified: full audit with `web/verify.ps1` — **109** files in manifest and offline bundle.

## Complete

| Item | Status |
|------|--------|
| SYLLABUS.md (16-week, modules 00–14) | Done |
| README, DOC-INDEX, QUICK-REFERENCE | Done |
| LEARNING-CHECKLIST + CAPSTONE-CHECKLIST | Done |
| MODULE-TEMPLATE.md | Done |
| Part folders (docs + sql indexes) | Done |
| Modules 00–14 docs + legacy 01–10 | Done |
| Exercises + solutions 00–14 | Done |
| SQL scripts 00–25 + ecommerce | Done |
| Appendices A–D | Done |
| Web viewer (`web/index.html`) | Done |
| Offline bundle (`web/content-bundle.js`) | Done — fixes "Failed to fetch" |
| `web/verify.ps1` + `web/rebuild-all.ps1` | Done |
| POST-NEXT-STEPS.md, WEB-VIEW.md | Done |

## Web viewer — how to verify

```powershell
cd "c:\Users\shaki\Desktop\SHAKIL\learn\sql server"
.\web\verify.ps1
```

Then open `web\index.html` (hard refresh `Ctrl+F5`). Status pill should show **Offline bundle ready**.

After editing any `.md` or `.sql`:

```powershell
.\web\rebuild-all.ps1
```

## Optional

| Item | Note |
|------|------|
| Bengali | [docs/14-bengali-summary.md](docs/14-bengali-summary.md) |
| SSIS/SSRS | See appendix D |

## Entry points

1. [SYLLABUS.md](SYLLABUS.md) — course order  
2. [web/index.html](web/index.html) — all docs in browser  
3. [sql/00-verify-instance.sql](sql/00-verify-instance.sql) — SSMS start  
