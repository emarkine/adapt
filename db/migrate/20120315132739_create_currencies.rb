class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.string :sign
      t.references :country
      t.string :state
    end
  end
end
