class Product < ApplicationRecord
  # --- RELATIONS ---
  belongs_to :category
  has_many :assortments, dependent: :destroy
  has_many :brands, through: :assortments
  has_many :store_products, dependent: :destroy
  has_many :stores, through: :store_products
  has_many :inventory_items, dependent: :destroy

  # --- NORMALISATIONS ---
  normalizes :name, with: ->(name) { name.strip }
  normalizes :ean, with: ->(ean) { ean.gsub(/\s+/, "") }

  # --- VALIDATIONS ---
  validates :name, presence: { message: "est obligatoire" }
  validates :ean,
            presence: { message: "est obligatoire" },
            uniqueness: { message: "est déjà utilisé par un autre produit" }

  # --- SCOPES ---
  scope :active, -> { where(is_discontinued: false) }
  scope :innovations, -> { where(is_innovation: true) }
  scope :discontinued, -> { where(is_discontinued: true) }
  scope :ordered, -> { order(name: :asc) }

  scope :search, ->(query) {
    where("name ILIKE ? OR ean LIKE ?", "%#{query}%", "%#{query}%")
  }

  scope :for_brand, ->(brand_id) {
    joins(:assortments).where(assortments: { brand_id: brand_id })
  }
end
