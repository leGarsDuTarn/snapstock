class AddCasesAddedToInventoryItems < ActiveRecord::Migration[8.2]
  def change
    add_column :inventory_items, :cases_added, :integer, default: 0, null: false
  end
end
