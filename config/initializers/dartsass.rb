# config/initializers/dartsass.rb
Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css"
}

# Important : initialiser comme un tableau vide si nil
Rails.application.config.dartsass.load_paths ||= []

# Ajouter le chemin node_modules
Rails.application.config.dartsass.load_paths << Rails.root.join("node_modules").to_s
