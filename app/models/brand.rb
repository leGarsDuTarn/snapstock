class Brand < ApplicationRecord
  # --- RELATIONS ---
  has_many :stores, dependent: :destroy
  has_many :strata, dependent: :destroy
  has_many :assortments, dependent: :destroy
  has_many :products, through: :assortments

  # --- NORMALISATIONS ---
  normalizes :name, with: ->(name) { name.strip.upcase }

  # --- VALIDATIONS ---
  validates :name,
            presence: { message: "est obligatoire" },
            uniqueness: { case_sensitive: false, message: "existe déjà" }
end
