// app/javascript/controllers/inventory_row_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["rupture", "quantity"];

  connect() {
    // On appelle la fonction au chargement pour gérer l'état initial
    // (par exemple si on revient d'une erreur de validation)
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
    // Ajout des styles visuels sur la ligne (this.element = le conteneur du controller)
    this.element.classList.add("bg-danger-subtle", "border-danger");

    // Désactivation de l'input quantité
    this.quantityTarget.value = 0;
    this.quantityTarget.disabled = true;
    this.quantityTarget.classList.add("text-muted");
  }

  setNormalState() {
    // Retrait des styles visuels
    this.element.classList.remove("bg-danger-subtle", "border-danger");

    // Réactivation de l'input
    this.quantityTarget.disabled = false;
    this.quantityTarget.classList.remove("text-muted");

    // UX: Si la valeur est 0, on la vide pour laisser la place à la saisie
    if (this.quantityTarget.value == "0") {
      this.quantityTarget.value = "";
    }
  }
}
