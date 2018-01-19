# http://www.theignatpost.ru/magazine/index.php?mlid=1198
# http://berg.com.ua/indicators-overlays/stdev/
class Indicator::Bollinger < Indicator

  def init(graph)
    @print = true
    super(graph)
  end

  def draw
    super(true)
  end

end

# SEllAR
=begin


  def to_s
    s = "Indicator[#{id}]: #{name}, period: #{@period}, standard_deviations: #{@standard_deviations}, "
    s += "bars: #{@bars.size}, points: #{@points.size}, #{Time.now.to_ms - @time} ms" if @print
    s
  end

  def init(graph)
    @time = Time.now.to_ms
    super(graph)
    # @print = true
    @period = setting.period
    @standard_deviations = setting.standard_deviations
    Service.start(:name => setting.name, :fund => @fund.id, :frame => @graph.frame,
                  :indicator => self.id, :setting => setting.id)
    # init_points
    puts "#{self}" if @print
  end

  # TD=√[(∑(x-xs)*(x-xs))/n]
  def calc_standard_deviations(point)
    xs = point.value
    if point.time == @bars.last.time # последний бар
      bars = @bars.last(@period-1)
      bars << @bars.last
    else
      bars = @bars.where('time <= ?', point.time).last(@period)
    end
    # puts "bars: #{bars.size}, last: #{bars.last.time}" if @print
    sum = 0.0
    bars.each do |bar|
      x = bar.rate # текущий курс
      diff = (x - xs).to_f # разница со средним
      sum += (diff * diff) # квадрат разницы
    end
    Math.sqrt(sum / @period) * @standard_deviations
  end

  def init_point(name,point,value)
    p = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                        :name => name, :time => point.time).first
    p = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                          :name => name, :time => point.time) unless p
    p.value = value
    p.save!
  end

  def init_points
    points = Point.where(:indicator_id => self.id, :fund_id => @fund.id,
                                    :frame_id => @frame.id, :name => setting.name).last(Graph::SIZE+1)
    points.each do |point| # проходим с первой точки до предпоследней
      if !point.level || (point == points.last) # стандартоное отклонение не было вычислено или это последняя точка
        level = calc_standard_deviations(point)
        init_point('bollinger_high',point,point.value + level)
        init_point('bollinger_low',point,point.value - level)
        init_point('bollinger_width',point,level)
      end
    end
  end

  def draw_by(name)
    set = settings.find_by_name name
    points = Point.where(:indicator_id => self.id, :fund_id => @fund.id,
                                    :frame_id => @frame.id, :name => name).last(Graph::SIZE+1)
    @graph.init_ind(points) if @graph.separate?
    puts "set: #{set.name}, draw: #{points.size} points " if @print
    draw_line(points, set.color, set.line_width, set.line_dash, set.radius) unless points.empty?
    draw_future_line(points, set.color, set.line_width, set.line_dash)
  end

  def draw
    if @graph.separate?
      draw_by('bollinger_width')
    else
      %w(bollinger bollinger_high bollinger_low).each do |name|
        draw_by(name)
      end
    end
  end

  # Индикатор получил сигнал от нейросети
  def pulse(impulse)
    super(impulse)
    # points = Indicator::Point.where(:indicator_id => self.id, :fund_id => @fund.id,
    #                                 :frame_id => @frame.id, :name => 'bol').last(4)
    # level, sign = level(angle(points))
    puts "sign: #{@sign}" if @print
    puts "level: #{@level}" if @print
    # puts "turn: #{@turn_level}" if @print
    assign('sign_bol', @sign)
    assign('level_bol', @level)
    assign('turn_bol', 0)
  end


def init_points_old
  @points = Indicator::Point.where('indicator_id = ? AND name = ? AND fund_id = ? AND frame_id = ? AND time >= ? AND time <= ?',
                                   self.id, 'bo', @fund.id, @frame.id, Time.at(@graph.begin_time), Time.at(@graph.end_time))
  @points_high = Indicator::Point.where('indicator_id = ? AND name = ? AND fund_id = ? AND frame_id = ? AND time >= ? AND time <= ?',
                                        self.id, 'bol_high', @fund.id, @frame.id, Time.at(@graph.begin_time), Time.at(@graph.end_time))
  @points_low = Indicator::Point.where('indicator_id = ? AND name = ? AND fund_id = ? AND frame_id = ? AND time >= ? AND time <= ?',
                                       self.id, 'bol_low', @fund.id, @frame.id, Time.at(@graph.begin_time), Time.at(@graph.end_time))

  (@bars.size-2).downto(@period) do |index|
    time = @bars[index].time
    init_point(time, 'bol_high', @points_high)
    init_point(time, 'bol_low', @points_low)
    point = @points_bol_high.where(:time => time).first
    unless point # если точки нет
      value = calc_standard_deviations(index) # считаем ее
      point = Indicator::Point.new(:indicator_id => self.id, :name => 'bol_high', :fund_id => @fund.id,
                                   :frame_id => @frame.id, :time => time, :value => value)
      point.save!
      puts point
    end
  end
end

def init(graph)
  super(graph)
end

# прорисовка лини  в будущее
def draw_future_line(points, shift, color)
  # # берем две последние опорные точки
  # a, b = points.last(2)
  # dx = (b[:time] - a[:time]).to_f
  # dy = b[:rate] - a[:rate]
  # c_time = (@graph.time + shift)
  # dx_ = (c_time - b[:time]).to_f
  # factor = (dx / dx_) * dy
  # c_rate = b[:rate] + factor
  # x1 = @graph.to_x(b[:time])
  # y1 = @graph.to_y(b[:rate])
  # x2 = @graph.to_x(c_time)
  # y2 = @graph.to_y(c_rate)
  # {name: 'line_to', x1: x1, y1: y1, x2: x2, y2: y2, size: 1, color: color}
end


# Индикатор получил сигнал с биржи
def pulse_(impulse, settings)
  # puts impulse
  @impulse = impulse
  @neuron = settings[:neuron]
  @input = settings[:input]
  @frame = Frame.parse(settings[:frame])
  @fund = impulse.fund
  @end_time = impulse.time.to_i
  @begin_time = @end_time - @frame.size * Graph::SIZE
  # @period = settings[:period].to_i
  # @method = settings[:method]
  if impulse.frame.size == 1 # вызов тикового слоя
    @list = Tick.init(@fund, @begin_time, @end_time, @frame.size) # загружаем тики
    # todo дополняем список предыдущем тиком в случае если тика нет
  else
    @list = Bar.init(@fund, @begin_time, @end_time, @frame.size) # загружаем нужные бары
  end
  @max = @list.max { |a, b| a.high <=> b.high }.high.to_f.round(@fund.comma)
  @min = @list.min { |a, b| a.low <=> b.low }.low.to_f.round(@fund.comma)
  @range = (@max - @min).round(@fund.comma)
  calc(impulse,settings)
  puts self
end

# находжение всех исходных данных для этого сигнала
def to_x(time)
  (((time.to_i - @begin_time).to_f / @period.to_f) * Graph::XX).round(1)
end

def to_y(rate)
  (((@max - rate.to_f) / @range) * Graph::YY).round(1)
end

# пересчет данных индикатора с занесением их в IndicatorData
def calc(impulse, settings)
  @input.init
  @list.each do |bar|
    @input.add(:time, bar.time)
    @input.add(:rate, bar.rate)
    @input.add(:x, to_x(bar.time))
    @input.add(:y, to_y(bar.rate))
    # @input.add(:rate => bar.rate, :time => bar.time, :x => to_x(bar.time), :y => to_y(bar.rate))
  end
  @input.store
end

def to_s
  s = super
  s += " { :frame => #{@frame}, "
  # s += " :fund => #{@fund.name}, "
  s += " :max => #{@max}, "
  s += " :min => #{@min}, "
  s += " range: => #{@range}, "
  # s += " : => #{@}, "
  s += " :list.size => #{@list.size} }" if @list
  s
end

=end