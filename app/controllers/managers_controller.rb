class ManagersController < ApplicationController
  before_action :set_store, only: %i[ new create ]
  before_action :set_manager, only: %i[ edit update destroy ]

  def new
    @manager = @store.managers.build
  end

  def create
    @manager = @store.managers.build(manager_params)
    if @manager.save
      redirect_to @store, notice: "Manager ajouté.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @manager.update(manager_params)
      redirect_to @manager.store, notice: "Manager mis à jour.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    store = @manager.store
    @manager.destroy
    redirect_to store, notice: "Manager retiré.", status: :see_other
  end

  private
    def set_store
      @store = Store.find(params[:store_id])
    end

    def set_manager
      @manager = Manager.find(params[:id])
    end

    def manager_params
      params.require(:manager).permit(:firstname, :lastname, :email, :phone, :role)
    end
end
