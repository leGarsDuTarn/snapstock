import { application } from "controllers/application";

import HelloController from "controllers/hello_controller";
application.register("hello", HelloController);

import InventoryRowController from "controllers/inventory_row_controller";
application.register("inventory-row", InventoryRowController);

export { application };
