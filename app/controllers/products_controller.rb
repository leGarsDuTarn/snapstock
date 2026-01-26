class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.includes(:category).ordered

    # Recherche simple
    if params[:query].present?
      @products = @products.search(params[:query])
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Produit créé.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Produit modifié.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produit supprimé.", status: :see_other
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      # brand_ids: [] permet de gérer les cases à cocher "Enseignes"
      params.require(:product).permit(:name, :ean, :pcb, :category_id, :is_innovation, :is_discontinued, brand_ids: [])
    end
end
