class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.string :code, null: false
    end
    add_index :countries, :code, unique: true
  end
end
