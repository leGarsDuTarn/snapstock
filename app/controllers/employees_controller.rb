class EmployeesController < ApplicationController
  before_action :set_store, only: %i[ new create ]
  before_action :set_employee, only: %i[ edit update destroy ]

  def new
    @employee = @store.employees.build
  end

  def create
    @employee = @store.employees.build(employee_params)
    if @employee.save
      redirect_to @store, notice: "Employé ajouté.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee.store, notice: "Employé mis à jour.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    store = @employee.store
    @employee.destroy
    redirect_to store, notice: "Employé retiré.", status: :see_other
  end

  private
    def set_store
      @store = Store.find(params[:store_id])
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:firstname, :lastname, :phone, :role)
    end
end
