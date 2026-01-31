import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="bootstrap"
export default class extends Controller {
  connect() {
    // On vérifie que Bootstrap est bien chargé via le CDN
    if (typeof bootstrap === "undefined") {
      console.warn("Bootstrap n'est pas encore chargé.");
      return;
    }

    // 1. Initialiser les Dropdowns manuellement (ceux qui posent souvent problème)
    const dropdownElementList =
      this.element.querySelectorAll(".dropdown-toggle");
    dropdownElementList.forEach((dropdownToggleEl) => {
      new bootstrap.Dropdown(dropdownToggleEl);
    });

    // 2. Initialiser les Tooltips (optionnel mais recommandé)
    const tooltipTriggerList = this.element.querySelectorAll(
      '[data-bs-toggle="tooltip"]',
    );
    tooltipTriggerList.forEach((tooltipTriggerEl) => {
      new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // 3. Initialiser les Popovers (optionnel)
    const popoverTriggerList = this.element.querySelectorAll(
      '[data-bs-toggle="popover"]',
    );
    popoverTriggerList.forEach((popoverTriggerEl) => {
      new bootstrap.Popover(popoverTriggerEl);
    });
  }
}
