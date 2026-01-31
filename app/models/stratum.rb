class Stratum < ApplicationRecord
  # --- RELATIONS ---
  belongs_to :brand
  has_many :stores
  has_many :assortments

  # --- NORMALISATIONS ---
  # On normalise en majuscules (ex: "  h1 " -> "H1")
  normalizes :name, with: ->(name) { name.strip.upcase }

  # --- VALIDATIONS ---
  validates :name, presence: { message: "doit être renseigné (ex: H1)" }

  validates :rank,
            presence: { message: "doit être renseigné pour définir l'ordre" },
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "doit être un nombre entier positif" }

  # SÉCURITÉ LOGIQUE :
  # Impossible d'avoir deux strates avec le même rang pour la même enseigne
  validates :rank, uniqueness: {
    scope: :brand_id,
    message: "existe déjà pour cette enseigne. Chaque niveau doit avoir un rang unique."
  }

  # Impossible d'avoir deux strates avec le même nom pour la même enseigne
  validates :name, uniqueness: {
    scope: :brand_id,
    case_sensitive: false,
    message: "existe déjà pour cette enseigne."
  }

  # --- SCOPES ---
  # Pour afficher les strates dans l'ordre croissant (10, 20, 30...)
  scope :ordered, -> { order(rank: :asc) }
end
