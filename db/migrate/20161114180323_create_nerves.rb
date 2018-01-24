class CreateNerves < ActiveRecord::Migration[5.1]
  def change
    create_table :nerves do |t|
      t.integer :node_id, null: false, index: true # нервный узел
      t.references :source, index: true #  нейрон источник сигнала
      t.references :recipient, index: true # нейрон получатель сигнала
      t.references :fund, index: true # среда
      t.references :frame, index: true # частота
      t.float :value, :default => 1 # чувствительность связи [-1..0..1] можно менять знак сигнала
      t.integer :level, :default => 0 # порог срабатывания нейрона [0..10], 0 - все проходит, 10 - все закрыто
    end
    # два нейрона могут иметь только одну связь в одном направлении.для одной комбинации фонда и частоты
    add_index(:nerves, [:source_id, :recipient_id, :node_id], :unique => true, :name => 'nerves_index')
    # add_index(:nerves, [:source_id, :recipient_id, :fund_id, :frame_id], :unique => true, :name => 'nerves_index')
  end
end


# class CreateNerves < ActiveRecord::Migration
#   def change
#     create_table :nerves do |t|
#       t.references :frame
#     end
#   end
# end
#
# class CreateNerves < ActiveRecord::Migration
#   def change
#     create_table :nerves do |t|
#       t.references :frame
#       # t.references :source, index: true #  нейрон источник сигнала
#       # t.references :recipient, index: true # нейрон получатель сигнала
#       # t.references :fund # среда
#       # t.references :frame # частота
#       # t.integer :limit, :default => 0 # порог срабатывания нейрона [0..10], 0 - все проходит, 10 - все закрыто
#       # t.float :value, :default => 1 # чувствительность связи [-1..1]
#     end
#     # два нейрона могут иметь только одну связь в одном направлении.для одной комбинации фонда и частоты
#     # add_index(:nerves, [:source_id, :recipient_id, :fund_id, :frame_id], :unique => true, :name => 'nerves_index')
#   end
# end
#
