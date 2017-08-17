class CreateFrames < ActiveRecord::Migration[5.1]
  def change
    create_table :frames do |t|
      t.string :name
      t.string :unit
      t.integer :duration
    end
    add_index(:frames, :name, :unique => true)
  end
end
