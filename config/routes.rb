Rails.application.routes.draw do
  # --- 1. AUTHENTIFICATION ---
  resources :registrations, only: %i[new create]
  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token, only: %i[new create edit update]

  # --- 2. DASHBOARD & RACINE ---
  # La page d'accueil est le tableau de bord
  root "dashboards#show"
  resource :dashboard, only: [ :show ]

  # --- 3. MÉTIER ---
  resources :stores do
    # shallow: true ->
    # - Pour créer : /stores/1/inventory_reports/new (Besoin de l'ID du magasin)
    # - Pour voir/modifier : /inventory_reports/5 (L'ID du rapport suffit, l'URL est courte)
    resources :inventory_reports, shallow: true
    resources :employees, shallow: true
    resources :managers, shallow: true
  end

  # --- 4. DONNÉES DE RÉFÉRENCE ---
  resources :products
  resources :brands
  resources :categories

  # --- 5. PWA (Progressive Web App) ---
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
