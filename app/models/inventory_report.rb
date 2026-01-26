class InventoryReport < ApplicationRecord
  belongs_to :store
  belongs_to :user

  # Trie les items par catégorie puis par nom pour faciliter la saisie en rayon
  has_many :inventory_items, -> { joins(:product).order("products.category_id ASC, products.name ASC") }, dependent: :destroy

  # Permet de sauver le rapport et ses 100 lignes produits en une seule fois
  accepts_nested_attributes_for :inventory_items, allow_destroy: true

  validates :report_date, presence: true
end
