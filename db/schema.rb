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

ActiveRecord::Schema[7.1].define(version: 2026_07_20_094036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_nav_metrics", force: :cascade do |t|
    t.bigint "daily_nav_id", null: false
    t.bigint "mutual_fund_id", null: false
    t.decimal "daily_return", precision: 12, scale: 8
    t.decimal "weekly_return", precision: 12, scale: 8
    t.decimal "monthly_return", precision: 12, scale: 8
    t.decimal "ytd_return", precision: 12, scale: 8
    t.decimal "volatility_30", precision: 12, scale: 8
    t.decimal "drawdown", precision: 12, scale: 8
    t.decimal "moving_average_7", precision: 18, scale: 6
    t.decimal "moving_average_30", precision: 18, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["daily_nav_id"], name: "index_daily_nav_metrics_on_daily_nav_id", unique: true
    t.index ["mutual_fund_id", "drawdown"], name: "index_daily_nav_metrics_on_mutual_fund_id_and_drawdown"
    t.index ["mutual_fund_id", "monthly_return"], name: "index_daily_nav_metrics_on_mutual_fund_id_and_monthly_return"
    t.index ["mutual_fund_id", "volatility_30"], name: "index_daily_nav_metrics_on_mutual_fund_id_and_volatility_30"
    t.index ["mutual_fund_id", "ytd_return"], name: "index_daily_nav_metrics_on_mutual_fund_id_and_ytd_return"
    t.index ["mutual_fund_id"], name: "index_daily_nav_metrics_on_mutual_fund_id"
  end

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
    t.decimal "previous_close", precision: 15, scale: 6
    t.decimal "change_percent", precision: 10, scale: 6
    t.date "provider_updated_at"
    t.string "provider_symbol"
    t.string "provider_exchange"
    t.index ["fetched_at"], name: "index_daily_navs_on_fetched_at"
    t.index ["mutual_fund_id", "nav_date"], name: "index_daily_navs_on_mutual_fund_id_and_nav_date", unique: true
    t.index ["mutual_fund_id"], name: "index_daily_navs_on_mutual_fund_id"
    t.index ["nav_date"], name: "index_daily_navs_on_nav_date"
    t.index ["provider_exchange"], name: "index_daily_navs_on_provider_exchange"
    t.index ["provider_symbol"], name: "index_daily_navs_on_provider_symbol"
    t.index ["raw_payload"], name: "index_daily_navs_on_raw_payload", using: :gin
    t.index ["source"], name: "index_daily_navs_on_source"
  end

  create_table "executive_briefings", force: :cascade do |t|
    t.date "as_of_date", null: false
    t.string "provider", null: false
    t.string "model", null: false
    t.string "status", default: "success", null: false
    t.text "prompt"
    t.text "briefing"
    t.text "error"
    t.datetime "generated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["as_of_date", "provider", "model"], name: "idx_executive_briefings_unique", unique: true
    t.index ["generated_at"], name: "index_executive_briefings_on_generated_at"
  end

  create_table "forecasts", force: :cascade do |t|
    t.bigint "mutual_fund_id", null: false
    t.date "target_date", null: false
    t.decimal "predicted_nav", precision: 18, scale: 8
    t.decimal "lower_bound", precision: 18, scale: 8
    t.decimal "upper_bound", precision: 18, scale: 8
    t.string "model_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "confidence_score", precision: 8, scale: 6
    t.datetime "predicted_at"
    t.string "horizon"
    t.decimal "expected_return_pct"
    t.index ["mutual_fund_id", "horizon", "target_date"], name: "idx_forecasts_unique", unique: true
    t.index ["mutual_fund_id"], name: "index_forecasts_on_mutual_fund_id"
  end

  create_table "ml_models", force: :cascade do |t|
    t.string "name", null: false
    t.string "version", null: false
    t.string "framework"
    t.string "algorithm"
    t.string "status", default: "development"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "version"], name: "index_ml_models_on_name_and_version", unique: true
  end

  create_table "ml_training_rows", force: :cascade do |t|
    t.bigint "mutual_fund_id", null: false
    t.bigint "daily_nav_id", null: false
    t.date "feature_date", null: false
    t.decimal "nav", precision: 18, scale: 8
    t.decimal "daily_return", precision: 18, scale: 8
    t.decimal "weekly_return", precision: 18, scale: 8
    t.decimal "monthly_return", precision: 18, scale: 8
    t.decimal "ytd_return", precision: 18, scale: 8
    t.decimal "moving_average_7", precision: 18, scale: 8
    t.decimal "moving_average_30", precision: 18, scale: 8
    t.decimal "volatility_30", precision: 18, scale: 8
    t.decimal "drawdown", precision: 18, scale: 8
    t.decimal "next_day_nav", precision: 18, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["daily_nav_id"], name: "index_ml_training_rows_on_daily_nav_id"
    t.index ["mutual_fund_id", "feature_date"], name: "idx_ml_training_rows_unique", unique: true
    t.index ["mutual_fund_id"], name: "index_ml_training_rows_on_mutual_fund_id"
  end

  create_table "mutual_funds", force: :cascade do |t|
    t.string "name", null: false
    t.string "isin", null: false
    t.string "figi"
    t.string "market_data_symbol"
    t.string "market_data_provider"
    t.string "currency", null: false
    t.string "domicile", null: false
    t.string "fund_house"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "exchange_code"
    t.string "security_type"
    t.string "market_sector"
    t.date "last_nav_date"
    t.datetime "last_market_data_sync_at"
    t.index ["active"], name: "index_mutual_funds_on_active"
    t.index ["figi"], name: "index_mutual_funds_on_figi", unique: true
    t.index ["isin"], name: "index_mutual_funds_on_isin", unique: true
    t.index ["last_nav_date"], name: "index_mutual_funds_on_last_nav_date"
    t.index ["market_data_symbol"], name: "index_mutual_funds_on_market_data_symbol"
  end

  add_foreign_key "daily_nav_metrics", "daily_navs"
  add_foreign_key "daily_nav_metrics", "mutual_funds"
  add_foreign_key "daily_navs", "mutual_funds"
  add_foreign_key "forecasts", "mutual_funds"
  add_foreign_key "ml_training_rows", "daily_navs"
  add_foreign_key "ml_training_rows", "mutual_funds"
end
