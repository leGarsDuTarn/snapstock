class InventoryReportsController < ApplicationController
  # Shallow routing : Besoin du store uniquement pour NEW, CREATE et INDEX
  before_action :set_store, only: %i[ index new create ]
  before_action :set_inventory_report, only: %i[ show destroy ]

  # GET /stores/1/inventory_reports/new
  def new
    @inventory_report = InventoryReport.new
    @inventory_report.store = @store
    @inventory_report.report_date = Date.today

    # PRÉ-REMPLISSAGE DU FORMULAIRE
    # Génère une ligne en mémoire pour chaque produit ACTIF du catalogue magasin
    # Triés par nom pour faciliter le travail en rayon
    @store.products.active.order(:name).each do |product|
      @inventory_report.inventory_items.build(product: product)
    end
  end

  # POST /stores/1/inventory_reports
  def create
    @inventory_report = @store.inventory_reports.new(inventory_report_params)
    @inventory_report.user = Current.user # On associe l'utilisateur connecté

    if @inventory_report.save
      # Redirection vers la fiche magasin après le relevé
      redirect_to @store, notice: "Relevé validé !", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /inventory_reports/1
  def show
    # Charge les items et les produits associés pour l'affichage
    @items = @inventory_report.inventory_items.includes(:product).order("products.name ASC")
  end

  # GET /stores/1/inventory_reports
  def index
    @inventory_reports = @store.inventory_reports.order(report_date: :desc)
  end

  # DELETE /inventory_reports/1
  def destroy
    store = @inventory_report.store # On le garde pour la redirection
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
          :missing_label,
          :cases_added
        ]
      )
    end
end
