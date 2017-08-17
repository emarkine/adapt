class CreateTicks < ActiveRecord::Migration[5.1]
  def change
    create_table :ticks do |t|
      t.references :fund, null: false
      t.timestamp :time, null: false # занимает 4 байт в отличии от datetime - 8
      t.integer :ms, null: false, :limit => 8
      t.decimal :rate, :precision => 12, :scale =>6, null: false
      t.integer :last_size
      t.integer :volume
      t.decimal :bid, :precision => 12, :scale =>6
      t.decimal :ask, :precision => 12, :scale =>6
      t.integer :bid_size
      t.integer :ask_size
    end
    add_index(:ticks, [:fund_id, :ms], :name => 'ticks_index', :unique => true)
    # add_index(:ticks, [:fund_id, :time, :ms, :rate], :name => 'ticks_index', :unique => true)
  end
end
