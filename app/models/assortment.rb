class Assortment < ApplicationRecord
  belongs_to :brand
  belongs_to :product

  # Un produit ne peut être qu'une seule fois dans l'assortiment d'une même enseigne
  validates :product_id, uniqueness: { scope: :brand_id, message: "est déjà dans l'assortiment de cette enseigne" }
end
