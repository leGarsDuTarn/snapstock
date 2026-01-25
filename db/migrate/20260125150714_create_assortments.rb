class CreateAssortments < ActiveRecord::Migration[8.2]
  def change
    create_table :assortments do |t|
      t.references :brand, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
