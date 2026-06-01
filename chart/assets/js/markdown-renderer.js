async function renderMarkdownFile(path, targetSelector) {
  const target = document.querySelector(targetSelector);
  if (!target) return;

  target.innerHTML = "<p>Loading lesson...</p>";

  try {
    let markdown = window.LEARNING_LIBRARY_MARKDOWN?.[path];

    if (!markdown || location.protocol !== "file:") {
      try {
        const response = await fetch(path, { cache: "no-store" });
        if (!response.ok) throw new Error(`Unable to load ${path}`);
        markdown = await response.text();
      } catch (error) {
        if (!markdown) throw error;
      }
    }

    target.innerHTML = marked.parse(markdown);

    if (window.mermaid) {
      target.querySelectorAll("pre code.language-mermaid").forEach((block) => {
        const wrapper = document.createElement("div");
        wrapper.className = "mermaid";
        wrapper.textContent = block.textContent;
        block.closest("pre").replaceWith(wrapper);
      });
      mermaid.initialize({
        startOnLoad: false,
        theme: document.documentElement.dataset.theme === "dark" ? "dark" : "default"
      });
      await mermaid.run({ nodes: target.querySelectorAll(".mermaid") });
    }
  } catch (error) {
    target.innerHTML = `<p class="error">${error.message}</p>`;
  }
}
