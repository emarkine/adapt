class Bar < ActiveRecord::Base
  # establish_connection :remote_production unless Rails.env.production?
  default_scope { order('time, frame_id') }
  belongs_to :fund
  belongs_to :frame
  belongs_to :next, :class_name => 'Bar', :foreign_key => :next_id
  belongs_to :prev, :class_name => 'Bar', :foreign_key => :prev_id
  # has_and_belongs_to_many :ticks
  # FIX_TIME = 1.hour # TODO по непонятной причине после перехода на летнее время тут возник глюк

  def to_s(long=false)
    return "Bar[#{id},#{time.strftime('%T')},#{rate.round(fund.comma)}]" unless long
    s = "Bar[#{id}], fund:  #{fund.name}, frame: #{frame.name}, "
    s += "#{Time.at(time).strftime('%T')}.#{Time.at(time).strftime('%F')} #{rate.round(fund.comma)} #{volume}"
    s += " [#{Time.at(self.open_time).strftime('%T')}-#{Time.at(self.close_time).strftime('%T')}]"
    s += " #{open.round(fund.comma)} #{high.round(fund.comma)} #{low.round(fund.comma)} #{close.round(fund.comma)}"
  end

  # вставка дополнительных n баров к началу переданного списка баров bars
  # TODO в случае, если запрашиваемые бары не находятся в базе, то запрос к Ticker для их создания
  def self.pre_add(bars, n)
    t1 = bars.first.time - n * bars.first.frame.id
    t2 = bars.last.time
    Bar.where('fund_id = ? AND frame_id = ? AND time >= ? AND time <= ?',
              bars.last.fund.id, bars.last.frame.id, t1, t2)
    # list << bars.last unless bars.last.id
  end

  # определение начала бара для заданного time в соответсвии с шагом step
  def bar_period(time, step)
    begin_time = (((lastTick.time.to_i) / step) * step)
  end

  # поиск первого предыдущего бара с учетом времени
  def self.find_prev(fund, time, step)
    # бар со временем меньшим заданному
    bar = Bar.where('fund_id = ? and frame = ? and time < ?', fund.id, step, Time.at(time)).last
    unless bar
      lastTick = Tick.where('fund_id = ? and time < ?', fund.id, Time.at(time)).last
      raise "No ticks available before #{Time.at(time)}], for: #{fund}" unless lastTick
      if !bar || bar.ticks.last != lastTick # если вдруг бара нет или у него не совподает тик с последним тиком в базе
        time = ((lastTick.time.to_i) / step) * step
        # time = bar_time(time, step)
        bar = Bar.new # то создаем его
        bar.frame = step # размер бара в секундах
        bar.init(fund, time, time + step - 1)
        bar.save!
      end
    end
    bar
  end

  # инициализация бара
  def self.init_bar_old(fund, open_time, close_time, step, prev)
    bar = Bar.new # то создаем его
    bar.fund = fund
    bar.open_time = open_time
    bar.close_time = close_time
    bar.frame = step # размер бара в секундах
    # средняя точка бара (удобно если bar выступает как tick)
    bar.time = open_time + ((close_time - open_time)/2)
    # выбираем тики соответствующие только этому бару
    ticks = Tick.where('fund_id = ? and time >= ? and time <= ?', fund.id, Time.at(open_time), Time.at(close_time))
    # glue
    if ticks.size > 0 # если тики есть, то вычисляем все нужные параметры бара
      bar.open = ticks.first.rate
      bar.close= ticks.last.rate
      bar.high = ticks.max { |a, b| a.rate <=> b.rate }.rate
      bar.low = ticks.min { |a, b| a.rate <=> b.rate }.rate
      # вычисляем простейшее арифметическое среднее (оно должно быть отличным от математического среднего)
      bar.rate = ticks.inject(0.0) { |sum, x| sum + x.rate } / ticks.size.to_f
      # если есть объем, то вычисляем его
      bar.volume = ticks.inject(0) { |sum, x| sum + x.volume } # if @ticks.first.volume
    elsif prev # если тиков нет, но есть предыдущий бар, то просто рисуем полоску на его уровне закрытия
      bar.open = prev.close
      bar.close = prev.close
      bar.high = prev.close
      bar.low = prev.close
      bar.rate = prev.close
      bar.volume = 0
    else # иначе возвращаем false - была неудачная инициализация (по идее мы сюда не должны добираться)
      raise "No ticks available [#{Time.at(open_time)} - #{Time.at(close_time)}] for #{fund}"
    end
    bar
  end

  # инициализация живого бара
  def self.init_last_bar(last)
    return unless last
    bar = Bar.new # то создаем его
    bar.fund = last.fund
    bar.frame = last.frame # размер бара в секундах
    open_time = last.close_time.to_i + 1 # сдвигаемся на секунду
    close_time = open_time + last.frame - 1
    bar.open_time = Time.at(open_time)
    bar.close_time = Time.at(close_time)
    # средняя точка бара (удобно если bar выступает как tick)
    bar.time = Time.at(open_time + (close_time - open_time)/2 + 1)
    # выбираем тики соответствующие только этому бару
    ticks = Tick.where('fund_id = ? and time >= ? and time <= ?', bar.fund.id, Time.at(open_time), Time.at(close_time))
    # glue
    if ticks.size > 0 # если тики есть, то вычисляем все нужные параметры бара
      bar.open = ticks.first.rate
      bar.close= ticks.last.rate
      bar.high = ticks.max { |a, b| a.rate <=> b.rate }.rate
      bar.low = ticks.min { |a, b| a.rate <=> b.rate }.rate
      # вычисляем простейшее арифметическое среднее (оно должно быть отличным от математического среднего)
      bar.rate = ticks.inject(0.0) { |sum, x| sum + x.rate } / ticks.size.to_f
      # если есть объем, то вычисляем его
      bar.volume = ticks.inject(0) { |sum, x| sum + x.volume } # if @ticks.first.volume
    else # если тиков нет, но есть предыдущий бар, то просто рисуем полоску на его уровне закрытия
      bar.open = last.close
      bar.close = last.close
      bar.high = last.close
      bar.low = last.close
      bar.rate = last.close
      bar.volume = 0
    end
    bar
  end

  #
  # def time
  #   t = read_attribute :time
  #   t - FIX_TIME
  # end
  #
  # def open_time
  #   t = read_attribute :open_time
  #   t - FIX_TIME
  # end
  #
  # def close_time
  #   t = read_attribute :close_time
  #   t - FIX_TIME
  # end

  # инициализация баров в заданном промежутке времени []begin_time..end_time], с шагом step
  def self.init(fund, begin_time, end_time, frame)
    # stime = Time.now.to_ms
    # округляем время до целого тайм фрейма и сдвигаемся на один шаг вправо, чтобы не вылезти за границу канваса
    begin_time = ((begin_time / frame) * frame) + frame
    end_time = end_time + frame # сдвигаемся на один бар вправо для считывания живого бара
    t1 = Time.at(begin_time)
    t2 = Time.at(end_time)
    # t1 = Time.at(begin_time + FIX_TIME)
    # t2 = Time.at(end_time + FIX_TIME)
    # находим бар предыдущий этому промежутку времени
    # prev = Bar.where('fund_id = ? AND frame = ? AND close_time < ?', fund.id, frame, Time.at(begin_time)).last
    index = 0 # индекс для массива баров
    bars = Bar.where('fund_id = ? AND frame_id = ? AND open_time >= ? AND close_time <= ?', fund.id, frame, t1, t2)
    puts "bars: #{bars.size}, frame: #{frame}"
    puts "last: #{bars.last}"
    # while (time <= (end_time-step)) # цикл по времени не включая последний бар
    #   close_time = time + step - 1
    #   bar = bars[index]
    #   # unless bar # надо создать бар
    #   #   prev = bars[index-1] if bars[index-1]
    #   #   # puts "bar[#{index}]"
    #   #   bar = Bar.init_bar(fund,time,close_time,step,prev)
    #   #   bar.save!
    #   #   bars << bar
    #   # end
    #   time = time + step # сдвигаем время для следующего цикла
    #   index += 1
    # end
    # создаем последний бар, но не сохраняем его в базе
    # bar = Bar.init_last_bar(bars.last)
    # # puts bar
    # bars << bar if bar
    # puts "Bar.init[#{bars.size}]: #{Time.now.to_ms - stime}"
    bars
  end

  # инициализация баров в заданном промежутке времени []begin_time..end_time], с шагом step
  def self.init_old(fund, begin_time, end_time, step)
    # stime = Time.now.to_ms
    bars = []
    # округляем время до целого тайм фрейма и сдвигаемся на один шаг вправо, чтобы не вылезти за границу канваса
    time = ((begin_time / step) * step) + step
    # находим бар предыдущий этому промежутку времени
    prev = Bar.find_prev(fund, time, step)
    # puts "prev: #{Time.now.to_ms - stime}"
    while (time <= end_time)
      # ptime = Time.now.to_ms
      # время закрытия бара должно быть на 1 секунду меньше времени открытия следующего
      close_time = time + step - 1
      # ищем бар в базе данных
      bar = Bar.where(:fund_id => fund.id, :open_time => time, :close_time => close_time).first
      # puts "bar[#{bar}].where: #{Time.now.to_ms - ptime}"
      unless bar # если его нет
        bar = Bar.new # то создаем его
        bar.frame = step # размер бара в секундах
        bar.prev = prev # связываем бар с предыдущим
        prev.next = bar if prev # предыдущий связываем с текущим
        bar.init(fund, time, close_time)
        # puts "bar[#{bar}].init: #{Time.now.to_ms - ptime}"
        if close_time <= end_time # если это не последний бар, то его сохраняем его
          bar.save!
          prev.save! if prev # также сохраняем предыдущий чтобы связать его с текущим
        end
        # puts "bar[#{bar}].save: #{Time.now.to_ms - ptime}"
      end
      time = time + step # сдвигаем время для следующего цикла
      bars << bar if bar # добавляем полученный бар в массив
      prev = bar if bar # задаем предыдущий для следующего цикла
    end
    # puts "Bar.init: #{Time.now.to_ms - stime}"
    bars
  end

  # инициализация бара
  def init(fund, open_time, close_time)
    self.fund = fund
    self.open_time = open_time
    self.close_time = close_time
    # средняя точка бара (удобно если bar выступает как tick)
    self.time = self.open_time + ((self.close_time - self.open_time)/2)
    # выбираем тики соответствующие только этому бару
    self.ticks = Tick.where('fund_id = ? and time >= ? and time <= ?', fund.id, Time.at(open_time), Time.at(close_time))
    # glue
    if self.ticks.size > 0 # если тики есть, то вычисляем все нужные параметры бара
      self.open = self.ticks.first.rate
      self.close= self.ticks.last.rate
      self.high = self.ticks.max { |a, b| a.rate <=> b.rate }.rate
      self.low = self.ticks.min { |a, b| a.rate <=> b.rate }.rate
      # вычисляем простейшее арифметическое среднее (оно должно быть отличным от математического среднего)
      self.rate = self.ticks.inject(0.0) { |sum, x| sum + x.rate } / self.ticks.size.to_f
      # если есть объем, то вычисляем его
      self.volume = self.ticks.inject(0) { |sum, x| sum + x.volume } # if @ticks.first.volume
      true
    elsif self.prev # если тиков нет, но есть предыдущий бар, то просто рисуем полоску на его уровне закрытия
      self.open = self.prev.close
      self.close = self.prev.close
      self.high = self.prev.close
      self.low = self.prev.close
      self.rate = self.prev.close
      self.volume = 0
      true
    else # иначе возвращаем false - была неудачная инициализация (по идее мы сюда не должны добираться)
      raise "No ticks available in [#{Time.at(open_time)} - #{Time.at(close_time)}], for: #{fund}"
      # false
    end
  end

  # склейка начала бара с концом предыдущего (если она нужна)
  def glue
    if self.prev && self.prev.ticks.last && self.prev.ticks.last != @ticks.first
      self.ticks.unshift(self.prev.ticks.last)
    end
  end

  #
  # def max_time
  #   ticks.where(:rate => self.max).first.time
  # end
  #
  # def min_time
  #   ticks.where(:rate => self.min).last.time
  # end

  def high?
    (self.open - self.close) < 0
  end

  def low?
    (self.open - self.close) > 0
  end

  def flat?
    (self.open - self.close) == 0
  end

  #
  # open_time
  #   |                                                     x
  #      |        - max                                   y +
  #      |                                                  |
  #      |                                                  |
  #   x  |                                                  |
  # y +-----+     - open                                    |
  #   |  w  |                                               |     вектор движения
  #   |     |                                               |
  #   |h    |                                               |
  #   |  *  |     - rate (арифметитечкое среднее)           |
  #   |     |                                               |
  #   +-----+     - close                                   |
  #      |                                                  |
  #      |                                                  |
  #      |        - min                                     |   -
  #          |
  #       close_time
  #
  #      |
  #    time
  #

  # выбираем цвет бара
  def bar_color
    if flat?
      '#555'
    elsif high?
      '#00cc00'
    elsif low?
      '#f40000'
    end
  end

  # выбираем цвет линий бара
  def bar_color_dark
    if flat?
      '#555'
    elsif high?
      '#348017'
    elsif low?
      '#700000'
    end
  end

  def draw(t0, period, max, range, width, height)
    list = []
    # y = (((max - self.rate) / range) * height.to_f).to_i
    # вычисляем вертикальную линию
    x_middle = (((self.time.to_i - t0).to_f/ period.to_f) * width).to_i
    y_max = (((max - self.high) / range) * height).to_i
    y_min = (((max - self.low) / range) * height).to_i
    # вычисляем прямоугольник
    x1 = (((self.open_time.to_i - t0).to_f/ period.to_f) * width).to_i + 1
    x2 = (((self.close_time.to_i - t0).to_f/ period.to_f) * width).to_i - 1
    y1 = (((max - self.open) / range) * height).round(1)
    y2 = (((max - self.close) / range) * height).round(1)
    y1, y2 = y2, y1 if (y1 > y2)
    list << {name: 'rect', x: x1, y: y1, width: (x2-x1), height: (y2-y1), :lineWidth => 0.5, color: bar_color_dark, fill: bar_color}
    # ((x1+1)..(x2-1)).step(2) do |x|
    #   list << {name: 'move', x: x, y: y1}
    #   list << {name: 'line', x: x, y: y2}
    #   list << {name: 'plot', width: 1, color: bar_color}
    # end
    # # обводим его
    # list << {name: 'move', x: x1, y: y1}
    # list << {name: 'line', x: x2, y: y1}
    # list << {name: 'line', x: x2, y: y2}
    # list << {name: 'line', x: x1, y: y2}
    # list << {name: 'line', x: x1, y: y1}
    # list << {name: 'plot', width: 1, color: bar_color_dark}
    # рисуем хвостики
    if (y1 > y_max)
      list << {name: 'move', x: x_middle, y: y1}
      list << {name: 'line', x: x_middle, y: y_max}
      list << {name: 'plot', width: 1, color: bar_color_dark}
    end
    if (y2 < y_min)
      list << {name: 'move', x: x_middle, y: y2}
      list << {name: 'line', x: x_middle, y: y_min}
      list << {name: 'plot', width: 1, color: bar_color_dark}
    end
    list
  end

  def draw_indicator(x, max, range, height)
    list = []
    # вычисляем вертикальную линию
    x_middle = x + 1.2
    y_max = (((max - self.high) / range) * height).to_i
    y_min = (((max - self.low) / range) * height).to_i
    # вычисляем прямоугольник
    y1 = (((max - self.open) / range) * height).to_i
    y2 = (((max - self.close) / range) * height).to_i
    y1, y2 = y2, y1 if (y1 > y2)
    bar_height = y2 - y1
    if bar_height > 0
      list << {name: 'rect', x: x, y: y1, width: 2.4, height: bar_height, color: bar_color_dark, fill: bar_color}
    else
      list << {name: 'line_to', x1: x, y1: y1, x2: x+2.4, y2: y1, width: 0.5, color: bar_color_dark}
    end
    # рисуем хвостики
    if (y1 > y_max)
      list << {name: 'line_to', x1: x_middle, y1: y1, x2: x_middle, y2: y_max, width: 0.5, color: bar_color_dark}
    end
    if (y2 < y_min)
      list << {name: 'line_to', x1: x_middle, y1: y2, x2: x_middle, y2: y_min, width: 0.5, color: bar_color_dark}
    end
    list
  end

  def x(graph)
    graph.to_x(self.open)
  end

  def y(graph)
    graph.to_y(self.rate)
  end

end
