class InventoryReportsController < ApplicationController
  # Charge le magasin pour les actions dépendantes du contexte store
  before_action :set_store, only: %i[index new create]

  # Charge le rapport d’inventaire pour les actions ciblées
  before_action :set_inventory_report, only: %i[show destroy]

  # GET /stores/:store_id/inventory_reports
  def index
    @inventory_reports = @store.inventory_reports.order(report_date: :desc)
  end

  # GET /stores/:store_id/inventory_reports/new
  def new
    # Initialise un nouveau rapport d’inventaire rattaché au magasin
    @inventory_report = @store.inventory_reports.new(report_date: Date.today)

    # Chargement du catalogue produit actif
    # Inclut les produits sans catégorie pour garantir l’exhaustivité
    products = Product.where(is_discontinued: false)
                      .left_joins(:category)
                      .order("categories.name ASC NULLS FIRST, products.name ASC")

    # Génération en mémoire d’une ligne d’inventaire par produit
    products.each do |product|
      @inventory_report.inventory_items.build(product: product)
    end
  end

  # POST /stores/:store_id/inventory_reports
  def create
    @inventory_report = @store.inventory_reports.new(inventory_report_params)
    @inventory_report.user = Current.user

    if @inventory_report.save
      # Redirection conforme aux exigences Turbo après création
      redirect_to store_path(@store),
                  notice: "Relevé validé avec succès.",
                  status: :see_other
    else
      # Ré-association des produits pour éviter les erreurs d’affichage du formulaire
      @inventory_report.inventory_items.each do |item|
        item.product ||= Product.find_by(id: item.product_id)
      end

      # Rendu du formulaire avec erreurs de validation
      render :new, status: :unprocessable_entity
    end
  end

  # GET /inventory_reports/:id
  def show
    @store = @inventory_report.store

    # Récupération et tri des lignes d’inventaire
    @items = @inventory_report.inventory_items
                              .joins(:product)
                              .includes(product: :category)
                              .order(
                                is_out_of_stock: :desc,
                                missing_label: :desc,
                              )
                              .order("products.name ASC")

    # Indicateurs clés
    @ruptures_count = @items.count(&:is_out_of_stock)
    @labels_count   = @items.count(&:missing_label)
    @colis_total    = @items.sum { |item| item.cases_added.to_i }
  end

  # DELETE /inventory_reports/:id
  def destroy
    store = @inventory_report.store
    @inventory_report.destroy

    # Redirection conforme aux exigences Turbo après suppression
    redirect_to store_path(store),
                notice: "Rapport supprimé définitivement.",
                status: :see_other
  end

  private

  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_inventory_report
    @inventory_report = InventoryReport.find(params[:id])
  end

  def inventory_report_params
    params.require(:inventory_report).permit(
      :report_date,
      :notes,
      inventory_items_attributes: [
        :id,
        :product_id,
        :is_out_of_stock,
        :missing_label,
        :cases_added
      ]
    )
  end
end
