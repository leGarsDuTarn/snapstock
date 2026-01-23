class CreateManagers < ActiveRecord::Migration[8.2]
  def change
    create_table :managers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
