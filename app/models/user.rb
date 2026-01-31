class User < ApplicationRecord
  has_secure_password

  # --- RELATIONS ---
  has_many :sessions, dependent: :destroy
  has_many :inventory_reports, dependent: :destroy

  # --- NORMALISATIONS ---
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # --- VALIDATIONS ---
  validates :email_address,
            presence: { message: "est obligatoire" },
            uniqueness: { message: "est déjà associé à un compte" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "n'est pas valide" }

  validates :password,
            length: { minimum: 8, message: "doit contenir au moins 8 caractères" },
            if: -> { password.present? }

  # --- HELPER ---
  def display_name
    email_address.split("@").first.capitalize
  end
end
