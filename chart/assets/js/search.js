async function loadLessons() {
  const fallback = window.LEARNING_LIBRARY_DATA?.["data/lessons.json"];
  if (location.protocol === "file:" && fallback) return fallback;

  try {
    const response = await fetch("data/lessons.json");
    if (!response.ok) throw new Error("Could not load lessons");
    return response.json();
  } catch (error) {
    if (fallback) return fallback;
    throw error;
  }
}

function lessonMatches(lesson, query, level) {
  const text = `${lesson.title} ${lesson.level} ${lesson.description} ${lesson.tags.join(" ")}`.toLowerCase();
  const levelOk = level === "all" || lesson.level === level;
  return levelOk && text.includes(query.toLowerCase());
}

async function setupGlobalSearch() {
  const input = document.querySelector("#globalSearchInput");
  const levelFilter = document.querySelector("#levelFilter");
  const results = document.querySelector("#searchResults");
  if (!input || !levelFilter || !results) return;

  const lessons = await loadLessons();

  function render() {
    const query = input.value.trim();
    const level = levelFilter.value;
    const matches = lessons.filter((lesson) => lessonMatches(lesson, query, level));
    results.innerHTML = matches.map((lesson) => `
      <a class="search-result" href="index.html?lesson=${encodeURIComponent(lesson.path)}">
        <h3>${lesson.title}</h3>
        <p>${lesson.description}</p>
        <div class="tag-row">${lesson.tags.map((tag) => `<span class="tag">${tag}</span>`).join("")}</div>
      </a>
    `).join("");
  }

  input.addEventListener("input", render);
  levelFilter.addEventListener("change", render);
  render();
}

window.addEventListener("DOMContentLoaded", setupGlobalSearch);
