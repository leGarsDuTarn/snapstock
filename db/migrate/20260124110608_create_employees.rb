class CreateEmployees < ActiveRecord::Migration[8.2]
  def change
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :role
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
