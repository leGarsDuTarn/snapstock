class AddNoShelfSpaceToInventoryItems < ActiveRecord::Migration[8.2]
  def change
    add_column :inventory_items, :no_shelf_space, :boolean, default: false, null: false
  end
end
