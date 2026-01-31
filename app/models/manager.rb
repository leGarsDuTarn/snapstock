class Manager < ApplicationRecord
  belongs_to :store, optional: true

  # --- NORMALISATIONS ---
  normalizes :firstname, with: ->(fn) { fn.strip.capitalize }
  normalizes :lastname, with: ->(ln) { ln.strip.upcase }
  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :role, with: ->(role) { role.strip.capitalize }

  # Pour le téléphone, retire tout ce qui n'est pas un chiffre
  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "email invalide" },
            allow_blank: true

  def formatted_phone
    return nil if phone.blank?
    phone.gsub(/(\d{2})(?=\d)/, '\1 ')
  end

  # Super pratique pour tes formulaires ou titres
  def full_name
    "#{firstname} #{lastname}"
  end
end
