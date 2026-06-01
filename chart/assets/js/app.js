async function getJson(path) {
  const fallback = window.LEARNING_LIBRARY_DATA?.[path];
  if (location.protocol === "file:" && fallback) return fallback;

  try {
    const response = await fetch(path);
    if (!response.ok) throw new Error(`Could not load ${path}`);
    return response.json();
  } catch (error) {
    if (fallback) return fallback;
    throw error;
  }
}

function titleCase(value) {
  return value.replace("-", " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

async function setupHome() {
  const tree = document.querySelector("#lessonTree");
  const cards = document.querySelector("#levelCards");
  const count = document.querySelector("#lessonCount");
  if (!tree && !cards) return;

  const lessons = await getJson("data/lessons.json");
  let currentLessonIndex = 0;
  if (count) count.textContent = lessons.length;

  const levels = [...new Set(lessons.map((lesson) => lesson.level))];

  function closeSidebar() {
    document.querySelector("[data-sidebar]")?.classList.remove("open");
  }

  function updateLessonControls() {
    const progress = document.querySelector("#lessonProgress");
    const previousButtons = [
      document.querySelector("#previousLesson"),
      document.querySelector("#previousLessonBottom")
    ];
    const nextButtons = [
      document.querySelector("#nextLesson"),
      document.querySelector("#nextLessonBottom")
    ];

    if (progress) {
      progress.textContent = `Lesson ${currentLessonIndex + 1} of ${lessons.length}`;
    }

    previousButtons.forEach((button) => {
      if (button) button.disabled = currentLessonIndex === 0;
    });

    nextButtons.forEach((button) => {
      if (button) button.disabled = currentLessonIndex === lessons.length - 1;
    });
  }

  function openLessonByIndex(index, options = {}) {
    if (index < 0 || index >= lessons.length) return;
    const { scrollToLesson = true } = options;
    currentLessonIndex = index;
    const lesson = lessons[currentLessonIndex];
    const link = document.querySelector(`[data-path="${CSS.escape(lesson.path)}"]`);

    document.querySelectorAll(".lesson-link").forEach((item) => item.classList.remove("active"));
    if (link) link.classList.add("active");

    document.querySelector("#currentLessonLabel").textContent = lesson.title;
    renderMarkdownFile(lesson.path, "#markdownContent");
    history.replaceState(null, "", `?lesson=${encodeURIComponent(lesson.path)}`);
    updateLessonControls();
    closeSidebar();
    if (scrollToLesson) {
      document.querySelector("#markdownContent")?.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }

  function setupLessonButton(id, direction) {
    const button = document.querySelector(id);
    if (!button) return;
    button.addEventListener("click", () => openLessonByIndex(currentLessonIndex + direction));
  }

  if (tree) {
    tree.innerHTML = levels.map((level) => {
      const links = lessons
        .filter((lesson) => lesson.level === level)
        .map((lesson) => `<a class="lesson-link" href="#" data-path="${lesson.path}">${lesson.title}</a>`)
        .join("");
      return `<section class="lesson-group"><h3>${titleCase(level)}</h3>${links}</section>`;
    }).join("");

    tree.addEventListener("click", (event) => {
      const link = event.target.closest("[data-path]");
      if (!link) return;
      event.preventDefault();
      const index = lessons.findIndex((lesson) => lesson.path === link.dataset.path);
      openLessonByIndex(index);
    });
  }

  const filter = document.querySelector("#lessonFilter");
  if (filter && tree) {
    filter.addEventListener("input", () => {
      const query = filter.value.toLowerCase();
      tree.querySelectorAll(".lesson-link").forEach((link) => {
        link.hidden = !link.textContent.toLowerCase().includes(query);
      });
    });
  }

  if (cards) {
    cards.innerHTML = levels.map((level) => {
      const levelLessons = lessons.filter((lesson) => lesson.level === level);
      return `<article class="card" data-level-card="${level}">
        <h3>${titleCase(level)}</h3>
        <p>${levelLessons.length} lessons covering ${levelLessons.slice(0, 3).map((lesson) => lesson.title).join(", ")}.</p>
        <div class="tag-row"><span class="tag">${levelLessons.length} lessons</span><span class="tag">Markdown</span></div>
      </article>`;
    }).join("");
  }

  const requestedLessonParam = new URLSearchParams(location.search).get("lesson");
  const requestedLesson = requestedLessonParam || lessons[0].path;
  setupLessonButton("#previousLesson", -1);
  setupLessonButton("#previousLessonBottom", -1);
  setupLessonButton("#nextLesson", 1);
  setupLessonButton("#nextLessonBottom", 1);
  const requestedIndex = lessons.findIndex((lesson) => lesson.path === requestedLesson);
  openLessonByIndex(requestedIndex >= 0 ? requestedIndex : 0, { scrollToLesson: Boolean(requestedLessonParam) });
}

async function setupRoadmap() {
  const timeline = document.querySelector("#roadmapTimeline");
  if (!timeline) return;
  const roadmap = await getJson("data/roadmap.json");
  timeline.innerHTML = roadmap.map((item) => `
    <article class="timeline-item">
      <h2>${item.phase}. ${item.title}</h2>
      <p>${item.goal}</p>
      <p><strong>Build evidence:</strong> ${item.outcomes.join(", ")}.</p>
      <div class="tag-row">${item.outcomes.map((outcome) => `<span class="tag">${outcome}</span>`).join("")}</div>
    </article>
  `).join("");
}

async function setupDiagrams() {
  const cards = document.querySelector("#diagramCards");
  const filter = document.querySelector("#diagramFilter");
  if (!cards || !filter) return;

  const diagrams = await getJson("data/diagrams.json");
  diagrams.forEach((diagram) => {
    const option = document.createElement("option");
    option.value = diagram.type;
    option.textContent = diagram.type;
    filter.appendChild(option);
  });

  function renderCards() {
    const selected = filter.value;
    const visible = selected === "all" ? diagrams : diagrams.filter((diagram) => diagram.type === selected);
    cards.innerHTML = visible.map((diagram) => `
      <article class="card" data-diagram-path="${diagram.path}">
        <h3>${diagram.title}</h3>
        <p>${diagram.description}</p>
        <div class="tag-row"><span class="tag">${diagram.type}</span><span class="tag">Mermaid</span></div>
      </article>
    `).join("");
  }

  filter.addEventListener("change", renderCards);
  cards.addEventListener("click", (event) => {
    const card = event.target.closest("[data-diagram-path]");
    if (card) renderMarkdownFile(card.dataset.diagramPath, "#diagramViewer");
  });
  renderCards();
}

window.addEventListener("DOMContentLoaded", () => {
  setupHome();
  setupRoadmap();
  setupDiagrams();
});
