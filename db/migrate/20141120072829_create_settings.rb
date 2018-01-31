class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name, null: false # имя для этих настроек
      t.references :indicator, null: false # для какого индикатора эти настройки
      t.integer :position, null: false  # место расположения настроек для сортировки
      # t.string :title # имя которое отображается в заголовке на странице
      # t.references :fund # специфические настройки для определенного фонда
      # t.references :frame # специфические настройки для определенного таймфрейма
      t.boolean :separate # индикатор рисуется в отдельном окне
      t.float :max # максимально возможное значение индикатора
      t.float :min # минимально возможное значение индикатора

      # настройки самого индикатора
      t.string :source # какие цены берутся для расчета: Close/Trade/Midpoint/VWAP/OHLC/High/Low
      t.integer :period # для EMA и SMA
      t.string :method # для MA - simple/exponential
      # t.integer :level # уровень срабатывания индикатора

      # для отображения индикатора
      t.string :color # цвет линии в формате #rgb или #RRGGBB
      t.string :fill # цвет заливки в формате #rgb или #RRGGBB
      t.float :line_width # толщина линии
      t.integer :line_dash # размера пунктира, если его нет - то рисуется сплошная линия
      t.float :radius # размер окружности, если она используется в прорисовке
      t.boolean :chart # отрисовка индикатора в виде гистограммы
      t.boolean :grid # отрисовка шкалы для доп. окна

      # дополнительные цвета для верха и низа
      t.string :color_high # цвет линии в формате #rgb или #RRGGBB
      t.string :fill_high # цвет заливки в формате #rgb или #RRGGBB
      t.string :color_low # цвет линии в формате #rgb или #RRGGBB
      t.string :fill_low # цвет заливки в формате #rgb или #RRGGBB

      # специфические настройки
      t.integer :delta # время задержки при вычислении результата в секундах

      # Line & Trend
      t.integer :level_depth # уровень проверки глубины по барам
      # t.integer :depth # глубина проверки по тикам
      # t.integer :last_depth # глубина проверки последнего тика

      # SAR
      t.float :incremental_step
      t.float :initial_step
      t.float :maximum_step

      # Bollinger
      t.float :standard_deviations

      #MACD
      t.string :first # первая ema для расчета
      t.string :second # вторая ema для расчета

      # здесь дополнительные настройки для каждого индикатора
      # t.text :properties

      t.string :link # ссылка на описание
      t.string :description # описание на русском

      # t.timestamps
    end

    add_index(:settings, :name, :unique => true)
  end
end
