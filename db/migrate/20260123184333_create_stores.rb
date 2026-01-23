class CreateStores < ActiveRecord::Migration[8.2]
  def change
    create_table :stores do |t|
      # Brand = Enseigne (ex: Carrefour)
      t.string :brand
      t.string :address
      t.string :zip_code
      t.string :city

      t.references :manager, null: true, foreign_key: true

      t.timestamps
    end
  end
end
