// app/javascript/controllers/inventory_row_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["rupture", "quantity"];

  connect() {
    this.toggleRupture();
  }

  toggleRupture() {
    if (this.ruptureTarget.checked) {
      this.setOutOfStockState();
    } else {
      this.setNormalState();
    }
  }

  setOutOfStockState() {
    // Ajoute un fond rouge léger et bordure rouge sur toute la ligne
    this.element.classList.add("bg-danger-subtle", "border-danger");

    // Gère l'input quantité
    this.quantityTarget.value = 0;
    this.quantityTarget.disabled = true;
    this.quantityTarget.classList.add("text-muted", "bg-secondary-subtle");
    this.quantityTarget.classList.remove("bg-light", "fw-bold");
  }

  setNormalState() {
    // Retire les styles d'alerte
    this.element.classList.remove("bg-danger-subtle", "border-danger");

    // Réactive l'input
    this.quantityTarget.disabled = false;
    this.quantityTarget.classList.remove("text-muted", "bg-secondary-subtle");
    this.quantityTarget.classList.add("bg-light", "fw-bold");

    // UX : Si c'est 0, on vide pour faciliter la saisie
    if (this.quantityTarget.value == "0") {
      this.quantityTarget.value = "";
    }
  }
}
