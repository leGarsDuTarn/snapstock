class CreateProducts < ActiveRecord::Migration[8.2]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.string :ean
      t.integer :pcb

      t.timestamps
    end
  end
end
