class CreateCrystals < ActiveRecord::Migration[5.1]
  def change
    create_table :crystals do |t|
      t.string :name, index: true, null: false
      t.references :indicator
      # t.references :robot
      # t.references :fund
      # t.references :frame
      # t.integer :in_id
      # t.integer :out_id
      # t.float :profit
      # t.decimal :profit, :precision => 6, :scale =>2
      # t.float :amount
      # t.decimal :amount, :precision => 6, :scale =>2
      # t.string :name
      # t.integer :level # выходной уровень
      # t.timestamps
    end
    add_index(:crystals, [:name], :name => 'crystals_index', :unique => true)
  end
end
