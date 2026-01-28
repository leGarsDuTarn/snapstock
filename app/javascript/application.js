// app/javascript/application.js

// 1. Charge Turbo
import "@hotwired/turbo-rails";

// 2. Charge tes controlleurs Stimulus
import "./controllers";

// 3. Charge Popper (nécessaire pour dropdowns/tooltips)
import "@popperjs/core";

// 4. Charge Bootstrap ET l'assigne à window
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;
