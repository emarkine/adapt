class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      # t.string :name
      t.references :setting
      # t.references :indicator
      t.references :fund
      t.references :frame
      t.references :service
      t.datetime :time, null: false
      t.integer :ms, null: false, :limit => 8
      t.decimal :value, :precision => 12, :scale =>6, null: false # значение индикатора на графике
      # t.boolean :last # признак последней точки
      t.float :alpha  # угол наклона в радианах
      t.float :derivative # производная
      t.float :second_derivative # вторая производная
      t.integer :angle_degrees # угол наклона в градусах
      # t.integer :angle # угол наклона [-9..9]
      # t.integer :turn # разворот [-9..9]
      # t.integer :trend # уровень тренда [-9..9]
      # t.integer :level # уровень индикатора [-9...9]
      # t.integer :sign # знак [-1,0,1]
      # t.boolean :last # последняя живая точка индикатора, которая должна перезаписываться каждый раз
      # t.integer :direction # направление движения индикатора (+1 => call) (-1 => put) (0 => nothing)
      t.integer :prev_id # предыдущая точка
      t.integer :next_id # следующая точка
    end
    # add_index(:points, [:setting_id, :fund_id, :frame_id, :time], :unique => true, :name => 'points_index')
    # add_index(:points, [:fund_id, :frame_id, :ms], :unique => true, :name => 'points_index')
  end
end

