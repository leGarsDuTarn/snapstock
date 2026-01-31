class Assortment < ApplicationRecord
  # --- RELATIONS ---
  belongs_to :brand
  belongs_to :product
  belongs_to :stratum 

  # --- VALIDATIONS ---
  validates :stratum_id, presence: { message: "doit être sélectionné (H1, H2...)" }

  # Unicité du couple Produit/Enseigne
  validates :product_id, uniqueness: {
    scope: :brand_id,
    message: "est déjà présent dans le cadencier de cette enseigne"
  }
end
