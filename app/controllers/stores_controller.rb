class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update destroy ]

  # GET /stores
  def index
    # Evite le N+1 query avec includes(:brand)
    @stores = Store.includes(:brand).ordered_by_city

    # Recherche via le scope défini dans le modèle
    if params[:query].present?
      @stores = @stores.search(params[:query])
    end
  end

  # GET /stores/1
  def show
    # Charge les dépendances pour l'affichage
    @managers = @store.managers
    @employees = @store.employees
    @recent_reports = @store.inventory_reports.order(report_date: :desc).limit(5)
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  def create
    @store = Store.new(store_params)

    if @store.save
      redirect_to @store, notice: "Magasin créé avec succès.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stores/1
  def update
    if @store.update(store_params)
      redirect_to @store, notice: "Magasin mis à jour.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /stores/1
  def destroy
    @store.destroy
    redirect_to stores_path, notice: "Magasin supprimé.", status: :see_other
  end

  private
    def set_store
      @store = Store.find(params[:id])
    end

    def store_params
      params.require(:store).permit(:brand_id, :address, :zip_code, :city, :personal_note)
    end
end
