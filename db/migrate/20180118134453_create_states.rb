class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :name, null: false # статус
      # t.string :status # состояние
      t.string :message # сообщение от сервиса
      t.references :service, null: false # сервис
      t.integer :ms, null: false, :limit => 8
      # t.datetime :time # время
    end
    add_index(:states, [:service_id, :ms], name: 'unique_states', :unique => true)
  end
end