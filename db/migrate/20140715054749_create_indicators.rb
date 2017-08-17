class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    create_table :indicators do |t|
      t.string :type, null: false # для наследования классов
      t.string :name, null: false # оснновное имя
      t.string :title, null: false # краткое сокращенное имя (абривеатура)
      t.string :full_name # полное имя
      t.integer :position # положение в для сортировки
      t.boolean :displayed # отбражается в toolbar
      t.string :canvas # если определено это поле, то отображается canvas внизу основного графика
      t.string :table # способ отображения таблицы
      t.string :link # ссылка на внешний ресурс с описанием индикатора

      # текущее состояние индикатора
      # t.integer :sign
    end
    add_index(:indicators, :name, :unique => true)
  end
end
