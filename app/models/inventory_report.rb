class InventoryReport < ApplicationRecord
  belongs_to :store
  belongs_to :user

  # Trie les items pour qu'ils apparaissent toujours dans le même ordre (ex: par nom de produit)
  has_many :inventory_items, -> { joins(:product).order("products.name ASC") }, dependent: :destroy

  # Permet de sauvegarder toutes les lignes de rupture d'un coup depuis le formulaire
  accepts_nested_attributes_for :inventory_items, allow_destroy: true

  validates :report_date, presence: true
  validates :cases_added, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :set_default_cases_added

  private

  def set_default_cases_added
    self.cases_added ||= 0
  end
end
