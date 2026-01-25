class AddIsDiscontinuedToProducts < ActiveRecord::Migration[8.2]
  def change
    add_column :products, :is_discontinued, :boolean, default: false
  end
end
