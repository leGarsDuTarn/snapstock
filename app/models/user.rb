class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :inventory_reports, dependent: :destroy

  # --- NORMALISATION ---
  # Nettoie l'email à l'entrée
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # --- VALIDATIONS ---
  # Validation du format d'email
  validates :email_address,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "doit être un email valide" }

  # Sécurité du mot de passe
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  # --- HELPER ---
  # Pour afficher "Bonjour admin" au lieu de "Bonjour admin@snapstock.com"
  def display_name
    email_address.split("@").first.capitalize
  end
end
