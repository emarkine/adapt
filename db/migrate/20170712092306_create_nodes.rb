class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.string :name
      t.string :title
      t.string :file
      t.date :date
    end
  end
end
