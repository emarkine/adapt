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

ActiveRecord::Schema.define(version: 20141221183931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bars", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "frame_id", null: false
    t.datetime "time", null: false
    t.bigint "ms", null: false
    t.datetime "open_time", null: false
    t.datetime "close_time", null: false
    t.decimal "rate", precision: 12, scale: 6, null: false
    t.decimal "open", precision: 12, scale: 6, null: false
    t.decimal "close", precision: 12, scale: 6, null: false
    t.decimal "high", precision: 12, scale: 6, null: false
    t.decimal "low", precision: 12, scale: 6, null: false
    t.integer "volume"
    t.boolean "last"
    t.integer "prev_id"
    t.integer "next_id"
    t.index ["frame_id"], name: "index_bars_on_frame_id"
    t.index ["fund_id", "frame_id", "open_time", "close_time"], name: "bars_index", unique: true
    t.index ["fund_id"], name: "index_bars_on_fund_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "sign", null: false
    t.bigint "country_id", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
    t.index ["country_id"], name: "index_currencies_on_country_id"
  end

  create_table "frames", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.integer "duration"
    t.index ["name"], name: "index_frames_on_name", unique: true
  end

  create_table "funds", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "full_name"
    t.string "isin"
    t.string "product"
    t.string "local_symbol"
    t.string "category"
    t.bigint "currency_id"
    t.string "exchange"
    t.string "primary_exchange"
    t.string "location"
    t.string "sector"
    t.string "industry"
    t.string "market_category"
    t.string "security_type"
    t.string "underlying"
    t.date "contract_month"
    t.datetime "expiration"
    t.integer "multiplier"
    t.integer "comma"
    t.string "direction"
    t.string "exercise_style"
    t.string "trading_class"
    t.string "product_type"
    t.string "issuer"
    t.string "settlement_method"
    t.time "open_time"
    t.time "close_time"
    t.decimal "prior_close", precision: 12, scale: 6
    t.string "url"
    t.string "xpath_rate"
    t.string "xpath_volume"
    t.string "xpath_bid"
    t.string "xpath_ask"
    t.string "xpath_bid_volume"
    t.string "xpath_ask_volume"
    t.boolean "watch"
    t.integer "show_index"
    t.text "note"
    t.index ["currency_id"], name: "index_funds_on_currency_id"
    t.index ["name"], name: "index_funds_on_name", unique: true
  end

  create_table "neurons", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "edge_id", null: false
    t.integer "position", null: false
    t.float "factor", default: 1.0
    t.index ["edge_id", "position"], name: "neurons_index", unique: true
    t.index ["edge_id"], name: "index_neurons_on_edge_id"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "setting_id"
    t.bigint "fund_id"
    t.bigint "frame_id"
    t.bigint "service_id"
    t.datetime "time", null: false
    t.bigint "ms", null: false
    t.decimal "value", precision: 12, scale: 6, null: false
    t.float "alpha"
    t.float "derivative"
    t.float "second_derivative"
    t.integer "angle_degrees"
    t.integer "prev_id"
    t.integer "next_id"
    t.index ["frame_id"], name: "index_points_on_frame_id"
    t.index ["fund_id"], name: "index_points_on_fund_id"
    t.index ["service_id"], name: "index_points_on_service_id"
    t.index ["setting_id"], name: "index_points_on_setting_id"
  end

  create_table "ticks", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.datetime "time", null: false
    t.bigint "ms", null: false
    t.decimal "rate", precision: 12, scale: 6, null: false
    t.integer "last_size"
    t.integer "volume"
    t.decimal "bid", precision: 12, scale: 6
    t.decimal "ask", precision: 12, scale: 6
    t.integer "bid_size"
    t.integer "ask_size"
    t.index ["fund_id", "ms"], name: "ticks_index", unique: true
    t.index ["fund_id"], name: "index_ticks_on_fund_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "username"
    t.string "password"
    t.date "birthday"
    t.string "mobile"
    t.string "site"
    t.bigint "currency_id", null: false
    t.bigint "country_id", null: false
    t.decimal "balance", precision: 10, scale: 2, default: "0.0", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["currency_id"], name: "index_users_on_currency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
