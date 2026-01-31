class InventoryReport < ApplicationRecord
  # --- RELATIONS ---
  belongs_to :store
  belongs_to :user

  # Trie les items par catégorie puis nom pour faciliter la saisie
  has_many :inventory_items, -> {
    joins(:product).order("products.category_id ASC, products.name ASC")
  }, dependent: :destroy

  accepts_nested_attributes_for :inventory_items, allow_destroy: true

  # --- VALIDATIONS ---
  validates :report_date, presence: { message: "doit être définie" }
end
