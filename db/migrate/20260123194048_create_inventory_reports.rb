class CreateInventoryReports < ActiveRecord::Migration[8.2]
  def change
    create_table :inventory_reports do |t|
      t.references :store, null: false, foreign_key: true
      t.date :report_date

      t.timestamps
    end
  end
end
