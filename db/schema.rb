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

ActiveRecord::Schema.define(version: 20180118134453) do

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

  create_table "crystals", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "indicator_id"
    t.index ["indicator_id"], name: "index_crystals_on_indicator_id"
    t.index ["name"], name: "crystals_index", unique: true
    t.index ["name"], name: "index_crystals_on_name"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "sign", null: false
    t.bigint "country_id", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
    t.index ["country_id"], name: "index_currencies_on_country_id"
  end

  create_table "data", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "frame_id", null: false
    t.bigint "neuron_id", null: false
    t.datetime "time", null: false
    t.integer "value", null: false
    t.integer "prev_id"
    t.integer "next_id"
    t.index ["frame_id"], name: "index_data_on_frame_id"
    t.index ["fund_id", "frame_id", "neuron_id", "time"], name: "data_index", unique: true
    t.index ["fund_id"], name: "index_data_on_fund_id"
    t.index ["neuron_id"], name: "index_data_on_neuron_id"
    t.index ["time"], name: "index_data_on_time"
  end

  create_table "edges", force: :cascade do |t|
    t.bigint "setting_id", null: false
    t.bigint "node_id"
    t.index ["node_id"], name: "index_edges_on_node_id"
    t.index ["setting_id"], name: "edges_index", unique: true
    t.index ["setting_id"], name: "index_edges_on_setting_id"
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

  create_table "hosts", force: :cascade do |t|
    t.string "name"
    t.string "model"
    t.string "ip"
    t.string "speed"
    t.string "processor"
    t.string "ram"
    t.string "hd"
    t.string "os"
    t.string "os_kernel"
    t.string "os_name"
    t.string "os_version"
    t.string "location"
    t.string "user"
    t.text "ssh_public_key"
    t.date "date"
    t.text "description"
    t.index ["name"], name: "hosts_index", unique: true
  end

  create_table "indicators", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.string "title", null: false
    t.string "full_name"
    t.integer "position"
    t.boolean "displayed"
    t.string "canvas"
    t.string "table"
    t.string "link"
    t.index ["name"], name: "index_indicators_on_name", unique: true
  end

  create_table "nerves", force: :cascade do |t|
    t.bigint "node_id"
    t.bigint "source_id"
    t.bigint "recipient_id"
    t.float "value", default: 1.0
    t.integer "level", default: 0
    t.index ["node_id", "source_id", "recipient_id"], name: "nerves_index", unique: true
    t.index ["node_id"], name: "index_nerves_on_node_id"
    t.index ["recipient_id"], name: "index_nerves_on_recipient_id"
    t.index ["source_id"], name: "index_nerves_on_source_id"
  end

  create_table "neurons", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "edge_id", null: false
    t.integer "position", null: false
    t.float "factor", default: 1.0
    t.index ["edge_id", "position"], name: "neurons_index", unique: true
    t.index ["edge_id"], name: "index_neurons_on_edge_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.string "type"
    t.string "title", null: false
    t.string "name", null: false
    t.string "description"
    t.text "text"
    t.date "date"
    t.time "time"
    t.string "file"
    t.integer "parent_id"
    t.integer "next_id"
    t.integer "prev_id"
    t.integer "x"
    t.integer "left_id"
    t.integer "right_id"
    t.integer "y"
    t.integer "up_id"
    t.integer "down_id"
    t.integer "z"
    t.integer "forward"
    t.integer "backward"
    t.index ["title"], name: "node_title_index", unique: true
  end

  create_table "parts", force: :cascade do |t|
    t.string "name"
    t.integer "count", default: 0
    t.text "description"
    t.string "link"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.bigint "setting_id"
    t.bigint "fund_id", null: false
    t.bigint "frame_id", default: 60, null: false
    t.integer "position"
    t.integer "trigger_id"
    t.string "ngroup"
    t.bigint "host_id", default: 1, null: false
    t.boolean "active"
    t.boolean "single"
    t.string "action"
    t.integer "refresh"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frame_id"], name: "index_services_on_frame_id"
    t.index ["fund_id"], name: "index_services_on_fund_id"
    t.index ["host_id"], name: "index_services_on_host_id"
    t.index ["setting_id", "fund_id", "frame_id"], name: "unique_service", unique: true
    t.index ["setting_id"], name: "index_services_on_setting_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "indicator_id", null: false
    t.integer "position"
    t.boolean "separate"
    t.float "max"
    t.float "min"
    t.string "source"
    t.integer "period"
    t.string "method"
    t.string "color"
    t.string "fill"
    t.float "line_width"
    t.integer "line_dash"
    t.float "radius"
    t.boolean "chart"
    t.boolean "grid"
    t.string "color_high"
    t.string "fill_high"
    t.string "color_low"
    t.string "fill_low"
    t.integer "delta"
    t.integer "level_depth"
    t.float "incremental_step"
    t.float "initial_step"
    t.float "maximum_step"
    t.float "standard_deviations"
    t.string "first"
    t.string "second"
    t.string "link"
    t.string "description"
    t.index ["indicator_id"], name: "index_settings_on_indicator_id"
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.string "message"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_statuses_on_service_id"
  end

  create_table "structures", force: :cascade do |t|
    t.bigint "crystal_id", null: false
    t.bigint "edge_id", null: false
    t.integer "position", null: false
    t.index ["crystal_id", "edge_id"], name: "structures_index", unique: true
    t.index ["crystal_id"], name: "index_structures_on_crystal_id"
    t.index ["edge_id"], name: "index_structures_on_edge_id"
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
    t.string "first_name", null: false
    t.string "last_name"
    t.string "email", null: false
    t.string "username"
    t.string "password"
    t.date "birthday"
    t.string "mobile"
    t.string "site"
    t.bigint "currency_id", null: false
    t.bigint "country_id", null: false
    t.decimal "balance", precision: 10, scale: 2, default: "0.0", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["currency_id"], name: "index_users_on_currency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "statuses", "services"
end
