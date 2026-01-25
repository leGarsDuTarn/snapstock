class Brand < ApplicationRecord
  has_many :stores
  has_many :assortments
  has_many :products, through: :assortments

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Supprime les espaces inutiles et capitalise proprement
  normalizes :name, with: ->(name) { name.strip.titleize }
end
