(function () {
  window.addEventListener("DOMContentLoaded", () => {
    const sidebar = document.querySelector("[data-sidebar]");
    const toggle = document.querySelector("[data-sidebar-toggle]");

    if (toggle && sidebar) {
      toggle.addEventListener("click", () => sidebar.classList.toggle("open"));
    }

    if (sidebar) {
      sidebar.addEventListener("click", (event) => {
        if (event.target.closest("a, button, [role='menuitem']")) {
          sidebar.classList.remove("open");
        }
      });
    }
  });
})();
