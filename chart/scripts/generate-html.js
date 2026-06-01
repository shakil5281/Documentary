const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const lessons = JSON.parse(fs.readFileSync(path.join(root, "data", "lessons.json"), "utf8"));
const outputDir = path.join(root, "generated");

fs.mkdirSync(outputDir, { recursive: true });

function escapeHtml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

for (const lesson of lessons) {
  const source = path.join(root, lesson.path);
  if (!fs.existsSync(source)) continue;
  const markdown = fs.readFileSync(source, "utf8");
  const filename = `${lesson.level}-${path.basename(lesson.path, ".md")}.html`.replaceAll("/", "-");
  const html = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(lesson.title)}</title>
  <link rel="stylesheet" href="../assets/css/style.css">
  <link rel="stylesheet" href="../assets/css/theme.css">
  <script defer src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
  <script defer src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
</head>
<body>
  <main class="single-page">
    <a class="button" href="../index.html">Back to Library</a>
    <article id="content" class="markdown-body"></article>
  </main>
  <script>
    const markdown = ${JSON.stringify(markdown)};
    document.getElementById("content").innerHTML = marked.parse(markdown);
    document.querySelectorAll("pre code.language-mermaid").forEach((block) => {
      const wrapper = document.createElement("div");
      wrapper.className = "mermaid";
      wrapper.textContent = block.textContent;
      block.closest("pre").replaceWith(wrapper);
    });
    mermaid.initialize({ startOnLoad: false });
    mermaid.run({ nodes: document.querySelectorAll(".mermaid") });
  </script>
</body>
</html>`;
  fs.writeFileSync(path.join(outputDir, filename), html);
}

console.log(`Generated ${lessons.length} static lesson pages in ${outputDir}`);
