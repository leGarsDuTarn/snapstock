class RemoveBrandStringAndAddBrandRefToStore < ActiveRecord::Migration[8.2]
  def change
    remove_column :stores, :brand, :string
    add_reference :stores, :brand, foreign_key: true
  end
end
