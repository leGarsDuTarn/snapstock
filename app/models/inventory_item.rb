class InventoryItem < ApplicationRecord
  belongs_to :inventory_report
  belongs_to :product
end
