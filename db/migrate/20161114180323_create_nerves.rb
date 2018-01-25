class CreateNerves < ActiveRecord::Migration[5.1]
  def change
    create_table :nerves do |t|
      t.references :node, index: true # нервный узел
      t.references :source, index: true #  нейрон источник сигнала
      t.references :recipient, index: true # нейрон получатель сигнала
      t.float :value, :default => 1 # чувствительность связи [-1..0..1] можно менять знак сигнала
      t.integer :level, :default => 0 # порог срабатывания нейрона [0..10], 0 - все проходит, 10 - все закрыто
    end
    # два нейрона могут иметь только одну связь в одном нервном узле
    add_index(:nerves, [:node_id, :source_id, :recipient_id], :unique => true, :name => 'nerves_index')
  end
end