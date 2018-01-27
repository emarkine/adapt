class CreateNeurons < ActiveRecord::Migration[5.1]
  def change
    create_table :neurons do |t|
      t.string :type, :null => false # тип нейрона
      t.string :name, null: false
      t.references :edge, :null => false  # грань кристалла
      t.integer :position, :null => false # место нахождения в грани
      t.float :factor, default: 1.0 # нормирующий множитель для расчета входных параметров [-9..0..9]
      # t.references :crystal, :null => false # к какому кристаллу относится
      # t.integer :level # уровень сигнала
      # t.references :setting # связь нейрона с индикатором через установки
      # t.references :layer # к какому слою относится
      # t.references :weight, :null => false # набор веса для нейрона
      # t.integer :weight, :default => 0 # значимость этого нейрона для старшего
      # t.string :description
    end
    # все нейроны строго позиционированны в грани
    add_index(:neurons, [:edge_id, :position], :name => 'neurons_index', :unique => true)
  end
end
