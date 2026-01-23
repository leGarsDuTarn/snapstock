class SplitNameInManagers < ActiveRecord::Migration[8.2]
  def change
    remove_column :managers, :name, :string

    add_column :managers, :firstname, :string
    add_column :managers, :lastname, :string
  end
end
