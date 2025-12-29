// App Version Switcher - Simple CSS Class Toggling
// No JSON parsing, no DOM manipulation - just show/hide pre-rendered content

document.addEventListener("DOMContentLoaded", function() {
  const versionSelects = document.querySelectorAll('.version-dropdown');

  versionSelects.forEach(select => {
    select.addEventListener('change', function() {
      const appName = this.dataset.appName;
      const selectedVersion = this.value;

      // Hide all version content for this app
      document.querySelectorAll(`[data-app="${appName}"][data-version]`).forEach(el => {
        el.classList.remove('active');
      });

      // Show selected version content
      document.querySelectorAll(`[data-app="${appName}"][data-version="${selectedVersion}"]`).forEach(el => {
        el.classList.add('active');
      });
    });
  });
});
