class InventoryItem < ApplicationRecord
  belongs_to :inventory_report
  belongs_to :product

  # Scopes pour sortir des stats rapidement
  scope :out_of_stock, -> { where(is_out_of_stock: true) }
  scope :missing_labels, -> { where(missing_label: true) }

  # Helper pour savoir si tout va bien sur ce produit
  def compliant?
    !is_out_of_stock && !missing_label
  end
end
