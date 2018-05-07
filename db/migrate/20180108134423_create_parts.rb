class CreateParts < ActiveRecord::Migration[5.1]
  def change
    create_table :parts do |t|
      t.string :name, null: :false
      t.integer :count, default: 0
      t.text :description
      t.string :link
      t.decimal :price, :precision => 8, :scale =>2
      t.timestamps
    end
  end
end
