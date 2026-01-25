class AddUserToInventoryReports < ActiveRecord::Migration[8.2]
  def change
    add_reference :inventory_reports, :user, null: false, foreign_key: true
  end
end
