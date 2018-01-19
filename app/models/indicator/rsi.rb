# http://www.theignatpost.ru/magazine/index.php?mlid=1946
# https://ru.wikipedia.org/wiki/%D0%98%D0%BD%D0%B4%D0%B5%D0%BA%D1%81_%D0%BE%D1%82%D0%BD%D0%BE%D1%81%D0%B8%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE%D0%B9_%D1%81%D0%B8%D0%BB%D1%8B
class Indicator::Rsi < Indicator

  def init(graph)
    # @print = true
    super(graph)
    @min = 0
    @max = 100
    @range = 100
  end

  def draw
    super(true)
    draw_horizontal_line(25)
    draw_horizontal_line(75)
  end

end

=begin

  def to_s
    s = "Indicator[#{id}]: #{name}, period: #{setting.period}, method: #{setting.method}"
    s += ", bars: #{@bars.size}" if @bars
    s += ", points: #{@points.size }" if @points
    s += ", #{Time.now.to_ms - @time} ms" if @time
  end

  def init(graph)
    @time = Time.now.to_ms
    # @print = true
    super(graph)
    init_points(@bars, setting.name, setting.period, setting.method)
  end

  def calc_ud(yesterday, today)
    if today.close > yesterday.close
      u = today.close - yesterday.close
      d = 0
    elsif today.close < yesterday.close
      u = 0
      d = yesterday.close - today.close
    else
      u = 0
      d = 0
    end
    [u, d]
  end

  def calc_ema(period, prev_ema, rate)
    alpha = 2.0 / (period + 1)
    (prev_ema + alpha * (rate - prev_ema)).round(@fund.comma)
  end

  def ema(aa, period)

  end

  def sma(aa, period)
    aa.inject { |sum, x| sum + x } / period
  end

  def calc_rsi(bars, index, period, method)
    uu = []
    dd = []
    (index-period+1).upto(index) do |i|
      u, d = calc_ud(bars[i-1], bars[i])
      uu << u
      dd << d
    end
    if method == 'simple'
      cu = sma(uu, period)
      cd = sma(dd, period)
      if cd == 0
        return 100.0
      else
        rs = cu / cd
      end
    elsif method == 'exponential'
      rs = ema(uu, period) / ema(dd, period)
    end
    rsi = 100.0 - (100.0 / (1.0 + rs))
    rsi.round
  end

  # инициализируем точки для rsi
  def init_points(bars, name, period, method)
    bars = Bar.pre_add(bars, period)
    # puts "bars: #{bars.size}, last: #{bars.last.time}" if @print
    (period+1).upto(bars.size-1) do |index| # проходим с конца до начала видимых баров
      bar = bars[index] # текущий бар соответсвующий точке расчета
      point = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                     :name => name, :time => bar.time).first
      if point.nil? # нет точки
        puts "[#{index}] #{bar}" if @print
        point = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id, :name => name,
                                         :time => bar.time, :value => calc_rsi(bars, index, period, method))
        puts "[#{index}] #{point}" if @print
      elsif (index == (bars.size-1)) # это последняя точка
        point.value = calc_rsi(bars, index, period, method)
        point.save!
      end
      prev = point
    end
  end

  def draw
    if @graph.mode == 'ind'
      # puts "draw: #{@points.size} points " if @print
      @graph.min = 0.0
      @graph.max = 100.0
      @graph.range = 100.0
      points = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                    :name => name).last(Graph::SIZE+1)
      draw_line(points, @color, @line_width, @line_dash)
      draw_future_line(points, @color, @line_width, @line_dash)
      puts "#{self}" if @print
    end
  end


  # Индикатор получил сигнал от нейросети
  def pulse(impulse)
    level, sign = level_sign()
    turn = 0
    puts "sign: #{sign}" if @print
    puts "level: #{level}" if @print
    puts "turn: #{turn}" if @print
    assign('sign_rsi', sign)
    assign('level_rsi', level)
    assign('turn_rsi', turn)
  end

=end