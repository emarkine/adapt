class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.string :name # имя хоста
      t.string :model # модель компьютера
      t.string :mac # его MAC адрес
      t.string :ip # его IP адрес
      t.string :speed # скорость загрузки/передачи Mbit/s
      t.string :processor # какой процессор
      t.string :ram # объем оперативной памяти
      t.string :hd # размер диска
      t.string :os # операционноая система
      t.string :os_kernel # ядро системы
      t.string :os_name # имя операционной системы
      t.string :os_version # версия операционной системы
      t.string :location # место расположения
      t.string :user # имя пользователя
      t.text :ssh_public_key # публичный ключ для ssh
      t.date :date # дата приобретения
      t.text :description # описание компьютера
    end
    add_index(:hosts, [:name], :unique => true, :name => 'hosts_index')
  end
end
