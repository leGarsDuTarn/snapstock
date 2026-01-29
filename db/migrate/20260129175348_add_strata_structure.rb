class AddStrataStructure < ActiveRecord::Migration[8.2]
  def change
    # 1. Création de la table des STRATES (H1, H2, SOC A...)
    create_table :strata do |t|
      t.string :name, null: false       # Le nom affiché (ex: "H1", "Supermarché")
      t.integer :rank, null: false      # Le niveau technique (ex: 10, 20, 30) pour le tri
      t.references :brand, null: false, foreign_key: true # Lié à une enseigne spécifique
      t.timestamps
    end

    # 2. Mise à jour de la table STORES (Magasins)
    add_reference :stores, :stratum, foreign_key: true

    # 3. Mise à jour de la table ASSORTMENTS (Le lien Produit-Enseigne)
    # Ajoute la strate (C'est ici qu'on dit "Ce produit est H1 chez Auchan")
    add_reference :assortments, :stratum, foreign_key: true
  end
end
