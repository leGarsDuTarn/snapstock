class AddPersonalNoteToStores < ActiveRecord::Migration[8.2]
  def change
    add_column :stores, :personal_note, :text
  end
end
