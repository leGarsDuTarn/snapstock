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

ActiveRecord::Schema[8.2].define(version: 2026_01_26_151930) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assortments", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_assortments_on_brand_id"
    t.index ["product_id"], name: "index_assortments_on_product_id"
  end

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "phone"
    t.string "role"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_employees_on_store_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer "cases_added", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "inventory_report_id", null: false
    t.boolean "is_out_of_stock"
    t.boolean "missing_label", default: false
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
    t.bigint "user_id", null: false
    t.index ["store_id"], name: "index_inventory_reports_on_store_id"
    t.index ["user_id"], name: "index_inventory_reports_on_user_id"
  end

  create_table "managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "firstname"
    t.string "lastname"
    t.string "phone"
    t.string "role"
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_managers_on_store_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.string "ean"
    t.boolean "is_discontinued", default: false
    t.boolean "is_innovation", default: false
    t.string "name"
    t.integer "pcb"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "store_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_store_products_on_product_id"
    t.index ["store_id"], name: "index_store_products_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "address"
    t.bigint "brand_id"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "name"
    t.text "personal_note"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["brand_id"], name: "index_stores_on_brand_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "assortments", "brands"
  add_foreign_key "assortments", "products"
  add_foreign_key "employees", "stores"
  add_foreign_key "inventory_items", "inventory_reports"
  add_foreign_key "inventory_items", "products"
  add_foreign_key "inventory_reports", "stores"
  add_foreign_key "inventory_reports", "users"
  add_foreign_key "managers", "stores"
  add_foreign_key "products", "categories"
  add_foreign_key "sessions", "users"
  add_foreign_key "store_products", "products"
  add_foreign_key "store_products", "stores"
  add_foreign_key "stores", "brands"
end
