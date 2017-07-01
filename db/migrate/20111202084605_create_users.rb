class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.date :birthday
      t.string :mobile
      t.string :site
      t.references :currency, null: false
      # t.integer :currency_id, null: false
      t.decimal :balance, precision: 10, scale: 2 , default: 0.0
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt
      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end