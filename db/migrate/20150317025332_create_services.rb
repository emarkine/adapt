class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name, null: false, index: true # обязательное и уникальное имя сервиса
      # t.references :indicator # индикатор
      t.references :setting # специфически установки индикатора
      t.references :fund, null: false # фонд
      t.references :frame, null: false, :default => 60  # таймфрейм
      t.integer :position # послеледовательность для запуска цепочки сервисов
      t.integer :trigger_id # иехрархические связи между сервисами для обновления
      t.string :ngroup # группа сервиса (просто имя group зарезервировано в Java Persistent)
      t.references :host, null: false, :default => 1 # компьютер, на котором запускается сервис
      t.boolean :active # запускается ли сервис по умолчанию
      t.boolean :single # признак одиночного/одноразового сервиса (напр. history)
      t.string :action # передача команды сервису
      t.integer :refresh # время обновления данных - run метод сервиса
      # t.references :crystal, null: false  # нейрокристал
      t.string :status  # состояние сервиса
      t.string :message  # сообщение от сервиса
      # t.date :date # поле нужно для работы в Java
      t.time :start_time # время точки начала работы сервиса
      t.time :stop_time # время точки окончания работы сервиса
      # t.integer :delta # установка времени задержки для этого сервиса
      t.timestamps
    end
    add_index(:services, [:name], :name => 'unique_service', :unique => true)
    # add_index(:services, [:setting_id, :fund_id, :frame_id], :name => 'unique_service', :unique => true)
  end

end
