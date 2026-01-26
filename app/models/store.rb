class Store < ApplicationRecord
  belongs_to :brand
  has_many :managers, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :inventory_reports
  has_many :store_products, dependent: :destroy
  has_many :products, through: :store_products

  after_create :import_brand_assortment

  validates :name, presence: { message: "doit être précisé (ex: Les Portes d'Albi)" }

  # --- NORMALISATIONS ---
  normalizes :city, with: ->(city) { city.strip.upcase }
  normalizes :zip_code, with: ->(zip) { zip.gsub(/\s+/, "") }
  normalizes :address, with: ->(addr) { addr.strip }

  # --- SCOPES ---
  scope :search, ->(query) {
    where("city ILIKE ? OR zip_code LIKE ?", "%#{query}%", "%#{query}%")
  }
  scope :by_brand, ->(brand_id) { where(brand_id: brand_id) }
  scope :ordered_by_city, -> { order(city: :asc) }
  scope :search, ->(query) {
    where("city ILIKE ? OR zip_code LIKE ?", "%#{query}%", "#{query}%")
  }
  scope :search, ->(query) {
    joins(:brand).where("stores.name ILIKE ? OR stores.city ILIKE ? OR brands.name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
  }

  private

  def import_brand_assortment
    return unless brand.present?
    brand.products.each do |product|
      StoreProduct.create(store: self, product: product)
    end
  end
end
