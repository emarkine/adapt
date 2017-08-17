class CreateBars < ActiveRecord::Migration[5.1]
  def change
    create_table :bars do |t|
      t.references :fund, null: false
      t.references :frame, null: false
      t.datetime :time, null: false
      t.integer :ms, null: false, :limit => 8
      t.datetime :open_time, null: false
      t.datetime :close_time, null: false
      t.decimal :rate, :precision => 12, :scale =>6, null: false
      t.decimal :open, :precision => 12, :scale =>6, null: false
      t.decimal :close, :precision => 12, :scale =>6, null: false
      t.decimal :high, :precision => 12, :scale =>6, null: false
      t.decimal :low, :precision => 12, :scale =>6, null: false
      t.integer :volume
      t.boolean :last # признак последнего бара
      t.integer :prev_id # ссылка на предыдущий бар
      t.integer :next_id # ссылка на следующий бар
    end
    add_index(:bars, [:fund_id, :frame_id, :open_time, :close_time], :name => 'bars_index', :unique => true)
    # add_index(:bars, [:fund_id, :frame_id, :ms], :name => 'bars_index', :unique => true)
  end
end


#
# open_time
#   |                                                     x
#      |        - max                                   y +
#      |                                                  |
#      |                                                  |
#   x  |                                                  |
# y +-----+     - open                                    |
#   |  w  |                                               |     вектор движения
#   |     |                                               |
#   |h    |                                               |
#   |  *  |     - rate (арифметическое среднее)           |
#   |     |                                               |
#   +-----+     - close                                   |
#      |                                                  |
#      |                                                  |
#      |        - min                                     |   -
#          |
#       close_time
#
#      |
#    time
#
