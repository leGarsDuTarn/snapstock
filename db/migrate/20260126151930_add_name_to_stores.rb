class AddNameToStores < ActiveRecord::Migration[8.2]
  def change
    add_column :stores, :name, :string
  end
end
