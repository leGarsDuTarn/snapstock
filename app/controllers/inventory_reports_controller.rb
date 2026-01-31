class InventoryReportsController < ApplicationController
  before_action :set_store, only: %i[index new create]
  before_action :set_inventory_report, only: %i[show destroy]

  def index
    @inventory_reports = @store.inventory_reports.order(report_date: :desc)
  end

  def new
    @inventory_report = @store.inventory_reports.new(report_date: Date.today)

    # 1. Tentative de chargement via l'assortiment (L'entonnoir)
    products = []
    if @store.stratum
      products = Product.joins(:assortments)
                        .where(assortments: { brand_id: @store.brand_id })
                        .where("assortments.stratum_id IN (?)",
                               @store.brand.strata.where("rank >= ?", @store.stratum.rank).pluck(:id))
                        .includes(:category)
    end

    # 2. Sécurité : Si l'assortiment est vide, on charge tout le catalogue actif
    if products.empty?
      products = Product.where(is_discontinued: false).includes(:category)
    end

    # 3. Tri par catégorie puis nom
    products = products.sort_by { |p| [p.category&.name || "Autres", p.name] }

    # 4. Construction des lignes
    products.each do |product|
      @inventory_report.inventory_items.build(product: product)
    end
  end

  def create
    @inventory_report = @store.inventory_reports.new(inventory_report_params)
    @inventory_report.user_id = current_user.id # On s'assure de l'ID du user
    @inventory_report.store = @store

    if @inventory_report.save
      redirect_to store_path(@store), notice: "Relevé validé avec succès.", status: :see_other
    else
      @inventory_report.inventory_items.each { |item| item.product ||= Product.find_by(id: item.product_id) }
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @store = @inventory_report.store
    @items = @inventory_report.inventory_items
                              .joins(:product)
                              .includes(product: :category)
                              .order(is_out_of_stock: :desc, no_shelf_space: :desc, missing_label: :desc)
                              .order("products.name ASC")

    @ruptures_count = @items.count(&:is_out_of_stock)
    @missing_count  = @items.count(&:no_shelf_space) # On compte no_shelf_space pour les manquants
    @labels_count   = @items.count(&:missing_label)
    @colis_total    = @items.sum { |item| item.cases_added.to_i }
  end

  def destroy
    store = @inventory_report.store
    @inventory_report.destroy
    redirect_to store_path(store), notice: "Rapport supprimé.", status: :see_other
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
      inventory_items_attributes: [
        :id,
        :product_id,
        :is_out_of_stock,
        :no_shelf_space, # C'est notre "Manquant"
        :missing_label,
        :cases_added
      ]
    )
  end
end
