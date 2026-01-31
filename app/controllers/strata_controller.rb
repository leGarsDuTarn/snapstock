class StrataController < ApplicationController
  # récupère l'enseigne uniquement pour les actions imbriquées (nested)
  before_action :set_brand, only: %i[index new create]

  # récupère la strate directement pour les actions membres (shallow)
  before_action :set_stratum, only: %i[edit update destroy]

  # GET /brands/:brand_id/strata
  def index
    # utilise le scope .ordered créé dans le modèle pour avoir le tri (10, 20, 30...)
    @strata = @brand.strata.ordered
  end

  # GET /brands/:brand_id/strata/new
  def new
    @stratum = @brand.strata.new
  end

  # POST /brands/:brand_id/strata
  def create
    @stratum = @brand.strata.new(stratum_params)

    if @stratum.save
      redirect_to brand_strata_path(@brand), notice: "Niveau #{@stratum.name} ajouté avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /strata/:id/edit
  def edit
    # @stratum est défini par le before_action
  end

  # PATCH/PUT /strata/:id
  def update
    if @stratum.update(stratum_params)
      # redirige vers la liste des strates de l'enseigne parente
      redirect_to brand_strata_path(@stratum.brand), notice: "Niveau mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /strata/:id
  def destroy
    # Garde le parent en mémoire pour la redirection avant de supprimer l'enfant
    brand = @stratum.brand

    @stratum.destroy

    redirect_to brand_strata_path(brand), notice: "Niveau supprimé."
  end

  private

  # Récupère l'enseigne depuis l'URL (ex: /brands/5/strata)
  def set_brand
    @brand = Brand.find(params[:brand_id])
  end

  # Récupère la strate depuis l'URL (ex: /strata/10/edit)
  def set_stratum
    @stratum = Stratum.find(params[:id])
  end

  # Strong Parameters : autorise que le nom et le rang
  def stratum_params
    params.require(:stratum).permit(:name, :rank)
  end
end
