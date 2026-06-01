(function () {
  const savedTheme = localStorage.getItem("library-theme") || "light";
  document.documentElement.dataset.theme = savedTheme;

  window.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("[data-theme-toggle]").forEach((button) => {
      button.addEventListener("click", () => {
        const nextTheme = document.documentElement.dataset.theme === "dark" ? "light" : "dark";
        document.documentElement.dataset.theme = nextTheme;
        localStorage.setItem("library-theme", nextTheme);
      });
    });
  });
})();
