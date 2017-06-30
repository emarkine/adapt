class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
    end
    add_index :countries, :code, unique: true
  end
end
