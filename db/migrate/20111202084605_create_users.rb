class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.date :birthday
      t.string :mobile
      t.string :site
      t.references :currency, null: false
      t.decimal :balance, precision: 10, scale: 2
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt
      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end