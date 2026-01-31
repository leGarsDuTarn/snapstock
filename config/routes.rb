Rails.application.routes.draw do
  # --- 1. AUTHENTIFICATION ---
  resources :registrations, only: %i[new create]
  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token, only: %i[new create edit update]

  # --- 2. DASHBOARD ---
  root "dashboards#show"
  resource :dashboard, only: [ :show ]

  # --- 3. MÉTIER & TERRAIN ---
  resources :stores do
    resources :inventory_reports, shallow: true
    resources :employees, shallow: true
    resources :managers, shallow: true
  end

  # --- 4. CONFIGURATION ENSEIGNES ---
  # Les strates et l'assortiment sont rattachés directement à la marque.
  resources :brands do
    # Routes pour l'import CSV
    member do
      get :import_assortment
      post :process_import
    end
    resources :strata, shallow: true
    resources :assortments, shallow: true
  end

  # --- 5. RÉFÉRENTIEL GLOBAL ---
  resources :products
  resources :categories

  # --- 6. PWA ---
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
