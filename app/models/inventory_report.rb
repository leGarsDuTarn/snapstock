class InventoryReport < ApplicationRecord
  belongs_to :store
  belongs_to :user

  has_many :inventory_items, dependent: :destroy
  accepts_nested_attributes_for :inventory_items
end
