class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def create
    # Cherche directement params[:email_address]
    if user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
      start_new_session_for user
      redirect_to root_path, notice: "Connecté !", status: :see_other
    else
      # Utilise .now pour que l'alerte s'affiche sur le render
      flash.now[:alert] = "Email ou mot de passe incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
