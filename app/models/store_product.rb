class StoreProduct < ApplicationRecord
  belongs_to :store
  belongs_to :product

  # Un magasin ne peut pas avoir deux fois le même produit dans sa liste locale
  validates :product_id, uniqueness: {
    scope: :store_id,
    message: "est déjà référencé dans ce magasin"
  }
end
