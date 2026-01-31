class Category < ApplicationRecord
  has_many :products

  normalizes :name, with: ->(name) { name.strip.capitalize }

  validates :name,
            presence: { message: "est obligatoire" },
            uniqueness: { case_sensitive: false, message: "existe déjà" }
end
