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

ActiveRecord::Schema[7.0].define(version: 2023_07_17_104744) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "discounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "percentage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_discounts_on_name", unique: true
  end

  create_table "flavours", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.float "base_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_flavours_on_name", unique: true
  end

  create_table "ingredients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.float "multiplier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "order_promotions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "promotion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_promotions_on_order_id"
    t.index ["promotion_id"], name: "index_order_promotions_on_promotion_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "total_price"
    t.integer "status", default: 0, null: false
    t.datetime "completed_at", precision: nil
    t.uuid "discount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_orders_on_discount_id"
  end

  create_table "pizza_ingredients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "pizza_id", null: false
    t.uuid "ingredient_id", null: false
    t.boolean "added", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_pizza_ingredients_on_ingredient_id"
    t.index ["pizza_id"], name: "index_pizza_ingredients_on_pizza_id"
  end

  create_table "pizzas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "flavour_id", null: false
    t.uuid "size_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flavour_id"], name: "index_pizzas_on_flavour_id"
    t.index ["order_id"], name: "index_pizzas_on_order_id"
    t.index ["size_id"], name: "index_pizzas_on_size_id"
  end

  create_table "promotions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "charge_for_item", null: false
    t.integer "serving_count", null: false
    t.uuid "flavour_id", null: false
    t.uuid "size_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flavour_id"], name: "index_promotions_on_flavour_id"
    t.index ["name"], name: "index_promotions_on_name", unique: true
    t.index ["size_id"], name: "index_promotions_on_size_id"
  end

  create_table "sizes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.float "multiplier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sizes_on_name", unique: true
  end

  add_foreign_key "order_promotions", "orders"
  add_foreign_key "order_promotions", "promotions"
  add_foreign_key "orders", "discounts"
  add_foreign_key "pizza_ingredients", "ingredients"
  add_foreign_key "pizza_ingredients", "pizzas"
  add_foreign_key "pizzas", "flavours"
  add_foreign_key "pizzas", "orders"
  add_foreign_key "pizzas", "sizes"
  add_foreign_key "promotions", "flavours"
  add_foreign_key "promotions", "sizes"
end
