const docs = [
  { module: "Start", title: "Repository Overview", path: "README.md" },
  { module: "Start", title: "Full Learning Process", path: "FULL_LEARNING_PROCESS.md" },
  { module: "Start", title: "Complete System Design Documentary", path: "COMPLETE_SYSTEM_DESIGN_DOCUMENTARY.md" },
  { module: "01 Basics", title: "Module Overview", path: "01-basics/README.md" },
  { module: "01 Basics", title: "Introduction to System Design", path: "01-basics/topics/01-introduction.md" },
  { module: "01 Basics", title: "Scalability and Performance", path: "01-basics/topics/02-scalability-and-performance.md" },
  { module: "01 Basics", title: "Load Balancing", path: "01-basics/topics/03-load-balancing.md" },
  { module: "01 Basics", title: "Caching", path: "01-basics/topics/04-caching.md" },
  { module: "01 Basics", title: "Database Fundamentals", path: "01-basics/topics/05-databases-fundamentals.md" },
  { module: "01 Basics", title: "Networking and APIs", path: "01-basics/topics/06-networking-and-apis.md" },
  { module: "01 Basics", title: "Back-of-envelope Math", path: "01-basics/topics/07-back-of-envelope-math.md" },
  { module: "01 Basics", title: "Exercise: URL Shortener Prep", path: "01-basics/exercises/exercise-01-url-shortener-prep.md" },
  { module: "02 Intermediate", title: "Module Overview", path: "02-intermediate/README.md" },
  { module: "02 Intermediate", title: "Consistency and Replication", path: "02-intermediate/topics/01-consistency-and-replication.md" },
  { module: "02 Intermediate", title: "Partitioning and Sharding", path: "02-intermediate/topics/02-partitioning-and-sharding.md" },
  { module: "02 Intermediate", title: "Message Queues and Async", path: "02-intermediate/topics/03-message-queues-and-async.md" },
  { module: "02 Intermediate", title: "Idempotency and Reliability", path: "02-intermediate/topics/04-idempotency-and-reliability.md" },
  { module: "02 Intermediate", title: "Design News Feed", path: "02-intermediate/topics/05-design-news-feed.md" },
  { module: "02 Intermediate", title: "Design Chat System", path: "02-intermediate/topics/06-design-chat-system.md" },
  { module: "02 Intermediate", title: "Design Notification System", path: "02-intermediate/topics/07-design-notification-system.md" },
  { module: "02 Intermediate", title: "Exercise: News Feed", path: "02-intermediate/exercises/exercise-01-news-feed.md" },
  { module: "02 Intermediate", title: "Exercise: Chat System", path: "02-intermediate/exercises/exercise-02-chat-system.md" },
  { module: "03 Advanced", title: "Module Overview", path: "03-advanced/README.md" },
  { module: "03 Advanced", title: "Distributed Consensus", path: "03-advanced/topics/01-consensus.md" },
  { module: "03 Advanced", title: "Distributed Transactions", path: "03-advanced/topics/02-distributed-transactions.md" },
  { module: "03 Advanced", title: "Global Scale", path: "03-advanced/topics/03-global-scale.md" },
  { module: "03 Advanced", title: "Payment Systems", path: "03-advanced/topics/04-payment-systems.md" },
  { module: "03 Advanced", title: "Rate Limiting and Gateways", path: "03-advanced/topics/05-rate-limiting-gateways.md" },
  { module: "03 Advanced", title: "Stream Processing", path: "03-advanced/topics/06-stream-processing.md" },
  { module: "03 Advanced", title: "Security at Scale", path: "03-advanced/topics/07-security-at-scale.md" },
  { module: "03 Advanced", title: "Exercise: Payment Gateway", path: "03-advanced/exercises/exercise-01-payment-gateway.md" },
  { module: "03 Advanced", title: "Exercise: Collaborative Editor", path: "03-advanced/exercises/exercise-02-collaborative-editor.md" },
  { module: "04 Deep Learning", title: "Module Overview", path: "04-deep-learning/README.md" },
  { module: "04 Deep Learning", title: "Intro to ML Systems", path: "04-deep-learning/topics/01-intro-to-ml-systems.md" },
  { module: "04 Deep Learning", title: "Distributed Training", path: "04-deep-learning/topics/02-distributed-training.md" },
  { module: "04 Deep Learning", title: "Model Serving and Inference", path: "04-deep-learning/topics/03-model-serving-inference.md" },
  { module: "04 Deep Learning", title: "Vector Search and Databases", path: "04-deep-learning/topics/04-vector-search-databases.md" },
  { module: "04 Deep Learning", title: "Recommendation Systems", path: "04-deep-learning/topics/05-recommendation-systems.md" },
  { module: "04 Deep Learning", title: "Large Language Model Systems", path: "04-deep-learning/topics/06-large-language-model-systems.md" },
  { module: "04 Deep Learning", title: "Audio and Video DL Pipelines", path: "04-deep-learning/topics/07-audio-video-dl-pipelines.md" },
  { module: "04 Deep Learning", title: "Exercise: TikTok Recommendation", path: "04-deep-learning/exercises/exercise-01-tiktok-recommendation.md" },
  { module: "04 Deep Learning", title: "Exercise: Enterprise LLM Chatbot", path: "04-deep-learning/exercises/exercise-02-llm-chatbot.md" }
];

const state = {
  activePath: new URLSearchParams(location.search).get("doc") || "README.md",
  completed: new Set(JSON.parse(localStorage.getItem("sd.completed") || "[]")),
  theme: localStorage.getItem("sd.theme") || "light"
};

const elements = {
  sidebar: document.querySelector("#sidebar"),
  menuButton: document.querySelector("#menuButton"),
  searchInput: document.querySelector("#searchInput"),
  navList: document.querySelector("#navList"),
  moduleLabel: document.querySelector("#moduleLabel"),
  docTitle: document.querySelector("#docTitle"),
  docPath: document.querySelector("#docPath"),
  readingTime: document.querySelector("#readingTime"),
  content: document.querySelector("#content"),
  toc: document.querySelector("#toc"),
  progressCount: document.querySelector("#progressCount"),
  progressBar: document.querySelector("#progressBar"),
  themeButton: document.querySelector("#themeButton"),
  completeButton: document.querySelector("#completeButton"),
  prevButton: document.querySelector("#prevButton"),
  nextButton: document.querySelector("#nextButton")
};

document.documentElement.dataset.theme = state.theme;

function escapeHtml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function slugify(value) {
  return value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
}

function inlineMarkdown(value) {
  let html = escapeHtml(value);
  html = html.replace(/`([^`]+)`/g, "<code>$1</code>");
  html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  html = html.replace(/\*([^*]+)\*/g, "<em>$1</em>");
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, (_, text, href) => {
    const doc = docs.find((item) => item.path.endsWith(href.replace(/^\.\//, "")));
    const target = doc ? `?doc=${encodeURIComponent(doc.path)}` : href;
    return `<a href="${escapeHtml(target)}">${escapeHtml(text)}</a>`;
  });
  return html;
}

function parseMarkdown(markdown) {
  const lines = markdown.replace(/\r\n/g, "\n").split("\n");
  const html = [];
  const headings = [];
  let i = 0;

  function closeList(type) {
    if (type) html.push(`</${type}>`);
  }

  while (i < lines.length) {
    const line = lines[i];

    if (/^```/.test(line)) {
      const lang = line.replace(/^```/, "").trim();
      const code = [];
      i += 1;
      while (i < lines.length && !/^```/.test(lines[i])) {
        code.push(lines[i]);
        i += 1;
      }
      html.push(`<pre><code class="language-${escapeHtml(lang)}">${escapeHtml(code.join("\n"))}</code></pre>`);
      i += 1;
      continue;
    }

    if (!line.trim()) {
      i += 1;
      continue;
    }

    const heading = /^(#{1,3})\s+(.+)$/.exec(line);
    if (heading) {
      const level = heading[1].length;
      const text = heading[2].replace(/\s+#+$/, "");
      const id = slugify(text);
      headings.push({ level, text, id });
      html.push(`<h${level} id="${id}">${inlineMarkdown(text)}</h${level}>`);
      i += 1;
      continue;
    }

    if (/^\|.+\|$/.test(line) && i + 1 < lines.length && /^\|[-:\s|]+\|$/.test(lines[i + 1])) {
      const headers = line.split("|").slice(1, -1).map((cell) => cell.trim());
      i += 2;
      const rows = [];
      while (i < lines.length && /^\|.+\|$/.test(lines[i])) {
        rows.push(lines[i].split("|").slice(1, -1).map((cell) => cell.trim()));
        i += 1;
      }
      html.push("<table><thead><tr>");
      headers.forEach((cell) => html.push(`<th>${inlineMarkdown(cell)}</th>`));
      html.push("</tr></thead><tbody>");
      rows.forEach((row) => {
        html.push("<tr>");
        row.forEach((cell) => html.push(`<td>${inlineMarkdown(cell)}</td>`));
        html.push("</tr>");
      });
      html.push("</tbody></table>");
      continue;
    }

    if (/^(-|\*)\s+/.test(line) || /^\d+\.\s+/.test(line) || /^- \[[ xX]\]\s+/.test(line)) {
      const ordered = /^\d+\.\s+/.test(line);
      const type = ordered ? "ol" : "ul";
      html.push(`<${type}>`);
      while (i < lines.length && ((ordered && /^\d+\.\s+/.test(lines[i])) || (!ordered && (/^(-|\*)\s+/.test(lines[i]) || /^- \[[ xX]\]\s+/.test(lines[i]))))) {
        let item = lines[i].replace(/^\d+\.\s+/, "").replace(/^(-|\*)\s+/, "");
        item = item.replace(/^\[ \]\s+/, '<input type="checkbox" disabled> ');
        item = item.replace(/^\[[xX]\]\s+/, '<input type="checkbox" checked disabled> ');
        html.push(`<li>${inlineMarkdown(item)}</li>`);
        i += 1;
      }
      closeList(type);
      continue;
    }

    if (/^>\s?/.test(line)) {
      const parts = [];
      while (i < lines.length && /^>\s?/.test(lines[i])) {
        parts.push(lines[i].replace(/^>\s?/, ""));
        i += 1;
      }
      html.push(`<blockquote>${parts.map(inlineMarkdown).join("<br>")}</blockquote>`);
      continue;
    }

    if (/^---+$/.test(line.trim())) {
      html.push("<hr>");
      i += 1;
      continue;
    }

    const paragraph = [line.trim()];
    i += 1;
    while (i < lines.length && lines[i].trim() && !/^(#{1,3})\s+/.test(lines[i]) && !/^```/.test(lines[i]) && !/^(-|\*)\s+/.test(lines[i]) && !/^\d+\.\s+/.test(lines[i]) && !/^\|.+\|$/.test(lines[i])) {
      paragraph.push(lines[i].trim());
      i += 1;
    }
    html.push(`<p>${inlineMarkdown(paragraph.join(" "))}</p>`);
  }

  return { html: html.join("\n"), headings };
}

function groupDocs(list) {
  return list.reduce((groups, doc) => {
    groups[doc.module] = groups[doc.module] || [];
    groups[doc.module].push(doc);
    return groups;
  }, {});
}

function renderNav() {
  const query = elements.searchInput.value.trim().toLowerCase();
  const filtered = docs.filter((doc) => {
    return !query || doc.title.toLowerCase().includes(query) || doc.path.toLowerCase().includes(query) || doc.module.toLowerCase().includes(query);
  });
  const groups = groupDocs(filtered);

  elements.navList.innerHTML = Object.entries(groups).map(([module, items]) => {
    const links = items.map((doc) => {
      const active = doc.path === state.activePath ? " active" : "";
      const done = state.completed.has(doc.path) ? " done" : "";
      return `<li><button class="nav-link${active}${done}" type="button" data-path="${doc.path}">
        <span class="status-dot" aria-hidden="true"></span>
        <span class="nav-title">${escapeHtml(doc.title)}</span>
      </button></li>`;
    }).join("");
    return `<section class="nav-section"><h3>${escapeHtml(module)}</h3><ul>${links}</ul></section>`;
  }).join("");
}

function renderProgress() {
  const total = docs.length;
  const done = docs.filter((doc) => state.completed.has(doc.path)).length;
  elements.progressCount.textContent = `${done} / ${total}`;
  elements.progressBar.style.width = `${Math.round((done / total) * 100)}%`;
}

function renderToc(headings) {
  const visible = headings.filter((heading) => heading.level <= 2);
  elements.toc.innerHTML = visible.length
    ? visible.map((heading) => `<a href="#${heading.id}">${escapeHtml(heading.text)}</a>`).join("")
    : "<span>No headings found</span>";
}

function updateButtons(index) {
  elements.prevButton.disabled = index <= 0;
  elements.nextButton.disabled = index >= docs.length - 1;
  elements.prevButton.textContent = index > 0 ? `Previous: ${docs[index - 1].title}` : "Previous";
  elements.nextButton.textContent = index < docs.length - 1 ? `Next: ${docs[index + 1].title}` : "Next";
}

async function loadDoc(path, pushState = true) {
  const doc = docs.find((item) => item.path === path) || docs[0];
  state.activePath = doc.path;

  elements.content.innerHTML = "<p>Loading lesson...</p>";
  const response = await fetch(`/content/${doc.path}`);
  if (!response.ok) {
    elements.content.innerHTML = `<p>Could not load <code>${escapeHtml(doc.path)}</code>.</p>`;
    return;
  }

  const markdown = await response.text();
  const parsed = parseMarkdown(markdown);
  const words = markdown.trim().split(/\s+/).filter(Boolean).length;

  elements.moduleLabel.textContent = doc.module;
  elements.docTitle.textContent = doc.title;
  elements.docPath.textContent = doc.path;
  elements.readingTime.textContent = `${Math.max(1, Math.ceil(words / 220))} min read`;
  elements.content.innerHTML = parsed.html;
  elements.completeButton.classList.toggle("completed", state.completed.has(doc.path));
  elements.completeButton.textContent = state.completed.has(doc.path) ? "Completed" : "Mark Complete";

  renderToc(parsed.headings);
  renderNav();
  renderProgress();
  updateButtons(docs.findIndex((item) => item.path === doc.path));
  elements.content.focus({ preventScroll: true });
  scrollTo({ top: 0, behavior: "smooth" });

  if (pushState) {
    history.pushState(null, "", `?doc=${encodeURIComponent(doc.path)}`);
  }
}

function saveCompleted() {
  localStorage.setItem("sd.completed", JSON.stringify([...state.completed]));
}

elements.navList.addEventListener("click", (event) => {
  const button = event.target.closest("[data-path]");
  if (!button) return;
  loadDoc(button.dataset.path);
  elements.sidebar.classList.remove("open");
});

elements.searchInput.addEventListener("input", renderNav);

elements.menuButton.addEventListener("click", () => {
  elements.sidebar.classList.toggle("open");
});

elements.themeButton.addEventListener("click", () => {
  state.theme = state.theme === "dark" ? "light" : "dark";
  document.documentElement.dataset.theme = state.theme;
  localStorage.setItem("sd.theme", state.theme);
});

elements.completeButton.addEventListener("click", () => {
  if (state.completed.has(state.activePath)) {
    state.completed.delete(state.activePath);
  } else {
    state.completed.add(state.activePath);
  }
  saveCompleted();
  renderNav();
  renderProgress();
  elements.completeButton.classList.toggle("completed", state.completed.has(state.activePath));
  elements.completeButton.textContent = state.completed.has(state.activePath) ? "Completed" : "Mark Complete";
});

elements.prevButton.addEventListener("click", () => {
  const index = docs.findIndex((doc) => doc.path === state.activePath);
  if (index > 0) loadDoc(docs[index - 1].path);
});

elements.nextButton.addEventListener("click", () => {
  const index = docs.findIndex((doc) => doc.path === state.activePath);
  if (index < docs.length - 1) loadDoc(docs[index + 1].path);
});

window.addEventListener("popstate", () => {
  const doc = new URLSearchParams(location.search).get("doc") || "README.md";
  loadDoc(doc, false);
});

renderNav();
renderProgress();
loadDoc(state.activePath, false);
