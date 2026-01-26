class InventoryReportsController < ApplicationController
  before_action :set_store, only: %i[ index new create ]
  before_action :set_inventory_report, only: %i[ show destroy ]

  def new
    @inventory_report = InventoryReport.new
    @inventory_report.store = @store
    @inventory_report.report_date = Date.today

    # Charge TOUT le catalogue produit actif (pas seulement ceux du magasin)
    # Utilise includes(:category) pour éviter de faire 100 requêtes SQL dans la vue
    products = Product.where(is_discontinued: false)
                      .includes(:category)
                      .order("categories.name ASC, products.name ASC")

    products.each do |product|
      # Prépare une ligne vide pour chaque produit du catalogue
      @inventory_report.inventory_items.build(product: product)
    end
  end

  def create
    @inventory_report = @store.inventory_reports.new(inventory_report_params)
    @inventory_report.user = Current.user # Assure-toi d'avoir défini Current.user

    if @inventory_report.save
      redirect_to store_path(@store), notice: "Relevé validé avec succès !", status: :see_other
    else
      # Si erreur, doit recharger la liste des items pour que le formulaire ne plante pas
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Trie les items : D'abord les ruptures, puis par nom
    @items = @inventory_report.inventory_items
                              .includes(:product)
                              .order(is_out_of_stock: :desc, missing_label: :desc)
  end

  def index
    @inventory_reports = @store.inventory_reports.order(report_date: :desc)
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
