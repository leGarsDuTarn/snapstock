class Employee < ApplicationRecord
  belongs_to :store

  # --- NORMALISATIONS ---
  normalizes :firstname, with: ->(fn) { fn.strip.capitalize }
  normalizes :lastname, with: ->(ln) { ln.strip.upcase }
  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }
  normalizes :role, with: ->(role) { role.strip.capitalize }

  def formatted_phone
    return nil if phone.blank?
    phone.gsub(/(\d{2})(?=\d)/, '\1 ')
  end

  # Super pratique pour tes formulaires ou titres
  def full_name
    "#{firstname} #{lastname}"
  end
end
