Rails.application.routes.draw do
  get "categories/index"
  get "categories/new"
  get "categories/create"
  get "categories/edit"
  get "categories/update"
  get "categories/destroy"
  get "brands/index"
  get "brands/new"
  get "brands/create"
  get "brands/edit"
  get "brands/update"
  get "brands/destroy"
  get "products/index"
  get "products/new"
  get "products/create"
  get "products/edit"
  get "products/update"
  get "products/destroy"
  get "employees/new"
  get "employees/create"
  get "employees/edit"
  get "employees/update"
  get "employees/destroy"
  get "managers/new"
  get "managers/create"
  get "managers/edit"
  get "managers/update"
  get "managers/destroy"
  get "inventory_reports/index"
  get "inventory_reports/show"
  get "inventory_reports/new"
  get "inventory_reports/create"
  get "inventory_reports/destroy"
  get "stores/index"
  get "stores/show"
  get "stores/new"
  get "stores/create"
  get "stores/edit"
  get "stores/update"
  get "stores/destroy"
  get "dashboards/show"
  # --- 1. AUTHENTIFICATION ---
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
