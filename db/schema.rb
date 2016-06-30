# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160630064343) do

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.integer  "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "countries", ["region_id"], name: "index_countries_on_region_id"

  create_table "ips", force: :cascade do |t|
    t.string   "address"
    t.integer  "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ips", ["region_id"], name: "index_ips_on_region_id"

  create_table "price_countries_product_variants", force: :cascade do |t|
    t.integer  "variant_id", limit: 8
    t.string   "name"
    t.float    "price"
    t.string   "currency"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "product_id", limit: 8
    t.integer  "region_id"
  end

  add_index "price_countries_product_variants", ["region_id"], name: "index_price_countries_product_variants_on_region_id"

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true

end
