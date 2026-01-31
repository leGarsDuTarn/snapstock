class InventoryItem < ApplicationRecord
  # --- RELATIONS ---
  belongs_to :inventory_report
  belongs_to :product

  # --- SCOPES ---
  scope :out_of_stock, -> { where(is_out_of_stock: true) }
  scope :missing_labels, -> { where(missing_label: true) }
  scope :not_implanted, -> { where(no_shelf_space: true) }

  # --- CALLBACKS ---
  # QApplique la logique métier AVANT de valider les données
  before_validation :apply_business_rules

  # --- VALIDATIONS ---
  # On s'assure qu'on ne rentre pas des nombres négatifs
  validates :cases_added, numericality: {
    greater_than_or_equal_to: 0,
    message: "ne peut pas être négatif"
  }

  # --- HELPERS (Pour ton affichage dans la vue) ---

  # Le produit est-il 100% conforme ? (Tout est vert)
  def compliant?
    !is_out_of_stock && !missing_label && !no_shelf_space
  end

  # A-t-il un problème quelconque ? (Pour afficher une alerte)
  def has_issue?
    !compliant?
  end

  private

  # --- LOGIQUE MÉTIER ---
  def apply_business_rules
    # RÈGLE 1 : Cascade du "Non Implanté"
    # Si le produit n'a pas de place en rayon (no_shelf_space),
    # alors il est techniquement indisponible pour le client (rupture).
    if no_shelf_space
      self.is_out_of_stock = true
    end

    # RÈGLE 2 : Cohérence des stocks
    # Si le produit est déclaré en rupture (que ce soit trou vide ou non implanté),
    # force le nombre de colis ajoutés à 0. On ne peut pas remplir un vide.
    if is_out_of_stock
      self.cases_added = 0
    end
  end
end
