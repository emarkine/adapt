class CreateFunds < ActiveRecord::Migration[5.1]
  def change
    create_table :funds do |t|
      t.string :name
      t.string :short_name
      t.string :full_name
      t.string :isin
      t.string :product
      t.string :local_symbol
      t.string :category #
      t.references :currency
      t.string :exchange
      t.string :primary_exchange
      t.string :location
      t.string :sector
      t.string :industry
      t.string :market_category
      t.string :security_type
      t.string :underlying
      t.date :contract_month
      t.datetime :expiration
      t.integer :multiplier
      t.integer :comma
      t.string :direction
      t.string :exercise_style
      t.string :trading_class
      t.string :product_type
      t.string :issuer
      t.string :settlement_method
      t.time :open_time
      t.time :close_time
      # t.time :available_open_time
      # t.time :available_close_time
      t.decimal :prior_close, :precision => 12, :scale =>6 # последнее дневное закрытие
      t.string :url
      t.string :xpath_rate
      t.string :xpath_volume
      t.string :xpath_bid
      t.string :xpath_ask
      t.string :xpath_bid_volume
      t.string :xpath_ask_volume

      t.boolean :watch # фонд выведен для работы
      t.integer :show_index # индекс для отображения
      # t.string :frame, :default => '10m'

      t.text :note
    end
    add_index(:funds, :name, :unique => true)
  end
end
