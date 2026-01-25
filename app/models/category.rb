class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Normalise en minuscules avec la première lettre en majuscule
  normalizes :name, with: ->(name) { name.strip.capitalize }
end
