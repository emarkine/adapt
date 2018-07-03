class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :name # состояние
      t.string :message # сообщение от сервиса
      t.references :service # сервис
      t.datetime :time # время
    end
  end
end