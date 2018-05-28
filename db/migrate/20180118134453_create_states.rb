class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :name, null: false # состояние
      t.string :message # сообщение от сервиса
      t.references :service, null: false  # сервис
      t.datetime :time, null: false, index: true # время
    end
  end
end