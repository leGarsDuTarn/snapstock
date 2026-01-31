class Store < ApplicationRecord
  # --- RELATIONS ---
  belongs_to :brand
  belongs_to :stratum, optional: true

  has_many :managers, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :inventory_reports, dependent: :destroy
  has_many :store_products, dependent: :destroy
  has_many :products, through: :store_products

  # --- NORMALISATIONS ---
  normalizes :name, with: ->(name) { name.strip }
  normalizes :city, with: ->(city) { city.strip.upcase }
  normalizes :zip_code, with: ->(zip) { zip.gsub(/\s+/, "") }
  normalizes :address, with: ->(addr) { addr&.strip }

  # --- VALIDATIONS ---
  validates :name, presence: { message: "doit être précisé (ex: Les Portes d'Albi)" }
  validates :city, presence: { message: "est obligatoire" }
  validates :zip_code, presence: { message: "est obligatoire" }

  # --- SCOPES ---
  scope :ordered_by_city, -> { order(city: :asc) }
  scope :by_brand, ->(brand_id) { where(brand_id: brand_id) }

  # Recherche globale (Nom, Ville ou Enseigne)
  scope :search, ->(query) {
    joins(:brand).where(
      "stores.name ILIKE :q OR stores.city ILIKE :q OR brands.name ILIKE :q OR stores.zip_code LIKE :q",
      q: "%#{query}%"
    )
  }

  # --- MÉTHODES MÉTIER ---

  # Retourne les produits que ce magasin est censé avoir selon sa strate
  def theoretical_catalog
    return Product.none unless stratum

    # Prend les produits dont la strate est <= à la strate du magasin
    Product.joins(assortments: :stratum)
           .where(assortments: { brand_id: brand_id })
           .where("strata.rank <= ?", stratum.rank)
           .distinct
  end

  def full_label
    "#{brand.name} - #{city} (#{stratum&.name})"
  end
end
