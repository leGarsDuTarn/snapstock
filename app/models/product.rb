class Product < ApplicationRecord
  belongs_to :category
  has_many :assortments, dependent: :destroy
  has_many :brands, through: :assortments
  has_many :store_products, dependent: :destroy
  has_many :stores, through: :store_products
  has_many :inventory_items, dependent: :destroy

  validates :name, :ean, presence: true
  validates :ean, uniqueness: true

  # --- NORMALISATIONS ---

  # Nettoyage automatique du nom (espaces blancs)
  normalizes :name, with: ->(name) { name.strip }

  # Nettoyage de l'EAN (supprime les espaces pour la cohérence base de données)
  normalizes :ean, with: ->(ean) { ean.gsub(/\s+/, "") }

  # --- SCOPES ---

  # 1. État du produit
  scope :active, -> { where(is_discontinued: false) }
  scope :innovations, -> { where(is_innovation: true) }
  scope :discontinued, -> { where(is_discontinued: true) }

  # 2. Recherche par nom ou EAN (ILike pour l'insensibilité à la casse sur Postgres)
  scope :search, ->(query) {
    where("name ILIKE ? OR ean LIKE ?", "%#{query}%", "%#{query}%")
  }

  # 3. Filtrage par Enseigne (Brand)
  scope :for_brand, ->(brand_id) {
    joins(:assortments).where(assortments: { brand_id: brand_id })
  }

  # 4. Filtrage par Catégorie
  scope :by_category, ->(category_id) { where(category_id: category_id) }

  # 5. Tri alphabétique par défaut
  scope :ordered, -> { order(name: :asc) }
end
