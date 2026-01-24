class AddIsInnovationToProducts < ActiveRecord::Migration[8.2]
  def change
    # Default: false, car la majorité des produits ne sont pas des innos
    add_column :products, :is_innovation, :boolean, default: false
  end
end
