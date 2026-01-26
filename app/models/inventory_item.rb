class InventoryItem < ApplicationRecord
  belongs_to :inventory_report
  belongs_to :product

  # Tes super scopes (On garde !)
  scope :out_of_stock, -> { where(is_out_of_stock: true) }
  scope :missing_labels, -> { where(missing_label: true) }

  # Validation de la quantité (Colis ajoutés)
  # NOTE : Assure-toi que ta colonne s'appelle bien 'quantity' dans la base de données
  validates :cases_added, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Nettoyage automatique : Si rupture cochée = 0 colis ajoutés
  before_save :zero_quantity_if_out_of_stock

  # Ton helper (On garde !)
  def compliant?
    !is_out_of_stock && !missing_label
  end

  private

  def zero_quantity_if_out_of_stock
    if is_out_of_stock
      self.quantity = 0
    end
  end
end
