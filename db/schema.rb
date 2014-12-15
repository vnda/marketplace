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

ActiveRecord::Schema.define(version: 20141126155232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "ml_products", force: true do |t|
    t.integer  "store_id"
    t.string   "vnda_id"
    t.string   "vnda_sku"
    t.string   "ml_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ml_products", ["store_id"], name: "index_ml_products_on_store_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "api_url"
    t.string   "api_user"
    t.string   "api_password"
    t.string   "token"
    t.string   "ml_token"
    t.string   "ml_app_id"
    t.string   "ml_secret"
    t.string   "ml_refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_update"
  end

end
