class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :command, null: false # передача команды сервису
      t.string :message # сообщение от сервиса
      t.references :service, null: false  # сервис
      t.references :host, null: false  # где выполняется сервис
      t.timestamps
    end
  end
end