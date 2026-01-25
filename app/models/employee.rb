class Employee < ApplicationRecord
  belongs_to :store

  # --- NORMALISATIONS ---
  normalizes :firstname, with: ->(fn) { fn.strip.capitalize }
  normalizes :lastname, with: ->(ln) { ln.strip.upcase }
  normalizes :phone, with: ->(phone) { phone.gsub(/\D/, "") }
  normalizes :role, with: ->(role) { role.strip.capitalize }
end
