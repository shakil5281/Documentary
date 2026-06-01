# Learning Documentary Library

A complete static documentation-based learning website for web development, software documentation, diagrams, and ERP enterprise architecture.

## What this project includes

- Markdown lessons in `docs/`
- Static HTML pages
- Responsive CSS
- Client-side JavaScript for search, sidebar navigation, filters, theme switching, and Markdown rendering
- Mermaid diagrams rendered in the browser
- JSON data indexes for lessons, roadmap, and diagram packs
- Optional static HTML generator script

## What this project does not include

- No backend application
- No database
- No API server
- No authentication
- No admin panel

## Run locally

Open `index.html` directly in your browser. The site includes `assets/js/offline-data.js`, so lessons, search, roadmap, and diagrams work without a local server.

A static server is optional:

```bash
cd chart
python -m http.server 5500
```

Open `http://localhost:5500`.

## Rebuild offline data

After editing files in `data/` or `docs/`, rebuild the offline browser bundle:

```bash
node scripts/build-offline-data.js
```

## Generate static lesson pages

```bash
node scripts/generate-html.js
```

This creates generated HTML files in `generated/` from the Markdown lesson index.
