class CreateInventoryItems < ActiveRecord::Migration[8.2]
  def change
    create_table :inventory_items do |t|
      t.references :inventory_report, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.boolean :is_out_of_stock

      t.timestamps
    end
  end
end
