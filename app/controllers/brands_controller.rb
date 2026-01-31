class BrandsController < ApplicationController
  before_action :set_brand, only: %i[ show edit update destroy import_assortment process_import ]

  def index
    @brands = Brand.all.order(:name)
  end

  def show
    @strata = @brand.strata
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to brands_path, notice: "Enseigne créée.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      redirect_to brands_path, notice: "Enseigne modifiée.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
    redirect_to brands_path, notice: "Enseigne supprimée.", status: :see_other
  end

  # --- METHODES D'IMPORT CSV ---

  def import_assortment
  end

  def process_import
    if params[:file].present?
      service = ImportAssortmentService.new(@brand, params[:file])
      report = service.call

      notice = "#{report[:success]} lignes traitées avec succès."
      notice += " Attention : #{report[:errors].count} erreurs." if report[:errors].any?

      redirect_to brand_path(@brand), notice: notice
    else
      redirect_to import_assortment_brand_path(@brand), alert: "Veuillez choisir un fichier."
    end
  end

  private
    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name)
    end
end
