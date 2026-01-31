class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.includes(:category).ordered

    if params[:query].present?
      @products = @products.search(params[:query])
    end
  end

  def show
    @assortments = @product.assortments.includes(:brand, :stratum)
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Fiche produit créée avec succès.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Fiche produit mise à jour.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produit supprimé définitivement.", status: :see_other
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :ean, :pcb, :category_id, :is_innovation, :is_discontinued)
    end
end
