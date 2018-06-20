class CreateData < ActiveRecord::Migration[5.1]
  def change
    create_table :data do |t|
      t.references :fund, null: false, index: true # актив
      t.references :frame, null: false, index: true # частота
      t.references :neuron, null: false, index: true # нейрон
      t.datetime :time, null: false, index: true # время
      t.integer :value, null: false # значение
      t.integer :prev_id # предыдущее данное
      t.integer :next_id # следующее данное
    end
    # add_index(:data, [:fund_id, :frame_id, :neuron_id, :time], :unique => true, :name => 'data_index')
  end
end
