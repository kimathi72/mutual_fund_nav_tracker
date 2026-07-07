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

ActiveRecord::Schema[7.1].define(version: 2026_07_07_104649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_navs", force: :cascade do |t|
    t.bigint "mutual_fund_id", null: false
    t.date "nav_date", null: false
    t.decimal "nav", precision: 15, scale: 6, null: false
    t.string "currency", null: false
    t.string "source", default: "yahoo_finance", null: false
    t.datetime "fetched_at", null: false
    t.jsonb "raw_payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fetched_at"], name: "index_daily_navs_on_fetched_at"
    t.index ["mutual_fund_id", "nav_date"], name: "index_daily_navs_on_mutual_fund_id_and_nav_date", unique: true
    t.index ["mutual_fund_id"], name: "index_daily_navs_on_mutual_fund_id"
    t.index ["nav_date"], name: "index_daily_navs_on_nav_date"
    t.index ["raw_payload"], name: "index_daily_navs_on_raw_payload", using: :gin
    t.index ["source"], name: "index_daily_navs_on_source"
  end

  create_table "mutual_funds", force: :cascade do |t|
    t.string "name", null: false
    t.string "isin", null: false
    t.string "figi"
    t.string "yahoo_symbol"
    t.string "currency", null: false
    t.string "domicile", null: false
    t.string "fund_house"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_mutual_funds_on_active"
    t.index ["figi"], name: "index_mutual_funds_on_figi", unique: true
    t.index ["isin"], name: "index_mutual_funds_on_isin", unique: true
    t.index ["yahoo_symbol"], name: "index_mutual_funds_on_yahoo_symbol"
  end

  add_foreign_key "daily_navs", "mutual_funds"
end
