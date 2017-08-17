# Прекрасный цикл статей по индикаторам
# http://www.theignatpost.ru/magazine/index.php?msid=140

class Indicator < ActiveRecord::Base
  include Draw
  default_scope { order(:position) }
  has_many :settings
  # has_many :crystals
  # has_many :neurons, :class_name => 'Neuro::Neuron'
  # belongs_to :frame
  # has_many :settings, :through => :neurons, :foreign_key => :indicator_settings_id

  validates :name, :presence => true, :uniqueness => true

  def to_s
    "Indicator[#{name}]"
  end

  def canvas?
    !self.canvas.blank?
  end

  def init(graph)
    @setting = settings.first
    draw_init(graph)
    # puts "indicator[#{name}].init: #{Time.now.to_ms - time} ms" if @print
  end

  def point(set)
    @points[set.name].last if @points && @points[set.name] && @points[set.name].size > 0
  end

  # выходной нейрон всегда один у каждого индикатора
  # def out
  #   neurons.where(:type => 'Neuro::OutNeuron').first
  # end

  def ps(set, graph, allFrames = false)
    t1 = graph.begin_time - graph.frame.id * 5
    t2 = graph.end_time + graph.frame.id
    if allFrames
      len = Point.where('setting_id = ? AND fund_id = ? ', set.id, graph.fund.id).size
      return [] if len == 0
      # todo делаю отрисовку без учета текущего фрейма
      Point.where('setting_id = ? AND fund_id = ? AND time >= ? AND time <= ?',
                  set.id, graph.fund.id, Time.at(t1), Time.at(t2))
    else
      len = Point.where('setting_id = ? AND fund_id = ? AND frame_id = ? ',
                        set.id, graph.fund.id, graph.frame.id).size
      return [] if len == 0
      # todo жуткие тормоза для этого запроса - ничего не могу сделать для ускорения
      Point.where('setting_id = ? AND fund_id = ? AND frame_id = ? AND time >= ? AND time <= ?',
                  set.id, graph.fund.id, graph.frame.id, Time.at(t1), Time.at(t2))
    end
  end

  # точки по которым рисуется кривая
  def init_points
    # return if @graph.begin_time.nil? || @graph.end_time.nil?
    settings.each do |set|
      # time = Time.now.to_ms
      # t1 = @graph.begin_time - @frame.id * 5
      # t2 = @graph.end_time + @frame.id
      # points = Indicator::Point.where('indicator_id = ? AND fund_id = ? AND frame_id = ? AND name = ? AND time >= ? AND time <= ?',
      #                                 self.id, @fund.id, @frame.id, set.name, Time.at(t1), Time.at(t2))
      # points = set.points.where(fund: @fund)
      # points = Point.where(setting: set, fund: @fund)
      # where_time = Time.now.to_ms
      # len = Point.where('fund_id = ? AND setting_id = ? AND frame_id = ? ', @fund.id, set.id, @frame.id).size
      # ps = Point.where('fund_id = ? AND setting_id = ? AND time >= ? AND time <= ?', @fund.id, set.id, Time.at(t1), Time.at(t2))
      # points = set.points.where('fund_id = ? AND time >= ? AND time <= ?', @fund.id, Time.at(t1), Time.at(t2))
      # len = set.points.where('fund_id = ? AND time >= ? AND time <= ?', @fund.id, Time.at(t1), Time.at(t2)).size
      # len = Point.where('fund_id = ? AND setting_id = ? AND frame_id = ? ', fund.id, set.id, frame.id).size
      len = ps(set, @graph, true).size
      # len = set.points.where('fund_id = ? AND time >= ? AND time <= ?', @fund.id, Time.at(t1), Time.at(t2)).size
      # puts "set[#{set.name}] found #{len} points: #{Time.now.to_ms - where_time} ms" if @print
      if len > 0 # найдены точки для текущего set
        @points[set.name] = ps(set,@graph, true)
        # необходимо вычислить верхние и нижние границы
        if set.separate
          # min = @points[set.name].min(:value)
          # max = @points[set.name].max(:value)
          min = @points[set.name].min { |a, b| a.value <=> b.value }.value
          max = @points[set.name].max { |a, b| a.value <=> b.value }.value
          @min ||= min
          @max ||= max
          @min = min if min < @min
          @max = max if max > @max
          @range = @max - @min
        end
      end
      # puts "set[#{set.name}].init_points: #{Time.now.to_ms - time} ms" if @print
    end
  end

  # прорисовка индикатора
  def draw(future = true)
    settings.reverse_each do |set| # обратный проход нужен для того, чтобы менее важная установка рисовалась последней
      next unless set.color || set.color_high # цвет не задан - ничего не рисуем
      # необходимо установить верхние и нижние границы для отдельного окна
      if @graph.separate? && set.separate?
        @graph.min = @min
        @graph.max = @max
        @graph.range = @range
        @graph.draw_rate_grid(5) if set.grid && @range
      end
      if @points[set.name] && @points[set.name].size > 0
        if @graph.separate? && set.chart?
          draw_chart(@points[set.name], set)
          draw_future_line(@points[set.name], set.color, set.line_width, set.line_dash) if future
        elsif @graph.separate? && set.separate?
          draw_line(@points[set.name], set.color, set.fill, set.line_width, set.line_dash, set.radius)
          draw_future_line(@points[set.name], set.color, set.line_width, set.line_dash) if future
        elsif !@graph.separate? && !set.separate?
          draw_line(@points[set.name], set.color, set.fill, set.line_width, set.line_dash, set.radius)
          draw_future_line(@points[set.name], set.color, set.line_width, set.line_dash) if future
        end
      end
    end
  end

  def draw_chart(points, set)
    y0 = @graph.to_y(0)
    points.each do |point|
      x = @graph.to_x(point.time) - 4
      y = @graph.to_y(point.value)
      height = (y - y0).abs
      y = y0 if point.value <= 0
      if set.color_high
        if point.value > 0
          @graph.list << {name: 'rect', x: x, y: y, width: 7, height: height, :color => set.color_high, :fill => set.fill_high}
        elsif point.value < 0
          @graph.list << {name: 'rect', x: x, y: y, width: 7, height: height, :color => set.color_low, :fill => set.fill_low}
        else
          @graph.list << {name: 'rect', x: x, y: y, width: 7, height: height, :color => set.color, :fill => set.fill}
        end
      else
        @graph.list << {name: 'rect', x: x, y: y, width: 7, height: height, :color => set.color, :fill => set.fill}
      end
    end
  end

  # прорисовка индикатора на основе setting
  def draw_set(name, future = true)
    set = settings.find_by_name name
    # points = Indicator::Point.where('indicator_id = ? AND fund_id = ? AND frame_id = ? AND name = ? AND time >= ? AND time <= ?',
    #                                 self.id, @fund.id, @frame.id, set.name, Time.at(@graph.begin_time), Time.at(@graph.end_time))
    points = Point.where('indicator_id = ? AND fund_id = ? AND name = ? AND time >= ? AND time <= ?',
                         self.id, @fund.id, set.name, Time.at(@graph.begin_time), Time.at(@graph.end_time))
    puts "set: #{set.name}"
    draw_line(points, set.color, set.fill, set.line_width, set.line_dash, set.radius)
    draw_future_line(points, set.color, set.line_width, set.line_dash) if future
  end

  def light
    'yellow'
  end

  def direction
    'call'
  end

  def call?
    direction == 'call'
  end

  # назначить всем нейронам определенного типа уровень наклона линии
  # def assign_level(name, points)
  #   neurons.where(:name => name).each do |n|
  #     n.level = value
  #     n.save!
  #   end
  # end

  # производная между двух точек
  def derivative(p1, p2)
    y = p2.value - p1.value
    x = p2.time - p1.time
    y.to_f / x.to_f
  end

  # расчет угла наклона
  def angle(points)
    return unless draw_future_line(points)
    line = @graph.list.last
    a = (line[:y1] - line[:y2]).to_f # a
    return 0 if a == 0
    b = (line[:x2] - line[:x1]).to_f # b
    c = Math.sqrt(a * a + b * b)
    # puts "[a, b, c]: [#{a}, #{b}, #{c}]"
    # puts "dy: #{dy}"
    # radian =  Math.asin( a / c )
    Math.asin(a / c) * Math::PI * 2.0
  end

  # перевод угла в уровень сигнала
  def translate_level(angle)
    # puts "angle: #{angle}"
    if angle == 0 || angle.nil?
      @level = 1
      @sign = 0
    elsif angle < 0
      @level = -1 + angle.round
      @sign = -1
    elsif angle > 0
      @level = 1 + angle.round
      @sign = 1
    else # NaN
      @level = 0
      @sign = 0
      # raise "wrong angle #{angle}"
    end
    @level = 9 if @level > 9
    @level = -9 if @level < -9
    [@level, @sign]
  end

  def level_sign(points=@points)
    translate_level(angle(points))
  end


  # Индикатор получил сигнал от нейросети
  def pulse
    points = []
    settings.each do |set|
      point = point(set) # берем последнюю точку для этого набора
      points << point
      # set.edge.pulse(impulse, point) if point # передаем импульс в грань кристалла
    end
    points
  end

  # создание хеша с именами индикаторов для отображения
  def self.session
    list = {}
    Indicator.all.each do |ind|
        list[ind.name] = false
    end
    list
  end

end


# Подвал
#
# def draw_bars
#   @graph.draw_bars_indicator
# end


# # должно быть переопределено для каждого индикатора
# def pulse(impulse, settings)
#   puts self
#   puts impulse
# end
#
# def impulse(fund, frame)
#   last_tick = fund.ticks.last
#   Indicator.all.each do |indicator|
#     indicator.indicator_settings.each do |setting|
#       time = Time.now
#       signal = IndicatorSignal.new(time, fund, frame, last_tick)
#       impulse = setting.indicator.impulse(signal)
#       setting.neuron.signal(impulse)
#     end
#   end
# end
