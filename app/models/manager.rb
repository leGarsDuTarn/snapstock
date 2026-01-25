class Manager < ApplicationRecord
  belongs_to :store, optional: true

  # --- NORMALISATIONS ---
  normalizes :firstname, with: ->(fn) { fn.strip.capitalize }
  normalizes :lastname, with: ->(ln) { ln.strip.upcase }
  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :role, with: ->(role) { role.strip.capitalize }

  # Pour le téléphone, retire tout ce qui n'est pas un chiffre
  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
