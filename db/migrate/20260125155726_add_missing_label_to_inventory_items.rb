class AddMissingLabelToInventoryItems < ActiveRecord::Migration[8.2]
  def change
    add_column :inventory_items, :missing_label, :boolean, default: false
  end
end
