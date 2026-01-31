import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  resolve(event) {
    const checkbox = event.target;
    const row = checkbox.closest(".item-row");

    const oosCheck = row.querySelector(".oos-check");
    const missCheck = row.querySelector(".miss-check");

    if (checkbox.checked) {
      // On décoche les alertes si on traite le produit
      oosCheck.checked = false;
      missCheck.checked = false;
      row.classList.add("row-resolved");
    } else {
      row.classList.remove("row-resolved");
    }
  }
}
