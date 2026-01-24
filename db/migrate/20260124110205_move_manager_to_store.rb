class MoveManagerToStore < ActiveRecord::Migration[8.2]
  def change
    # 1. Coupe le lien dans le mauvais sens
    remove_reference :stores, :manager, index: true, foreign_key: true

    # 2. Crée le lien dans le bon sens
    # Un manager est rattaché à un magasin
    add_reference :managers, :store, null: true, foreign_key: true
  end
end
