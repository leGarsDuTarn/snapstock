# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.2].define(version: 2026_01_24_104737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "inventory_report_id", null: false
    t.boolean "is_out_of_stock"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_report_id"], name: "index_inventory_items_on_inventory_report_id"
    t.index ["product_id"], name: "index_inventory_items_on_product_id"
  end

  create_table "inventory_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "report_date"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_inventory_reports_on_store_id"
  end

  create_table "managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "firstname"
    t.string "lastname"
    t.string "phone"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.string "ean"
    t.boolean "is_innovation", default: false
    t.string "name"
    t.integer "pcb"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "address"
    t.string "brand"
    t.string "city"
    t.datetime "created_at", null: false
    t.bigint "manager_id"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["manager_id"], name: "index_stores_on_manager_id"
  end

  add_foreign_key "inventory_items", "inventory_reports"
  add_foreign_key "inventory_items", "products"
  add_foreign_key "inventory_reports", "stores"
  add_foreign_key "products", "categories"
  add_foreign_key "stores", "managers"
end
