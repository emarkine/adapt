# http://www.theignatpost.ru/magazine/index.php?mlid=948
class Indicator::MovingAverage < Indicator

  def init(graph)
    @time = Time.now.to_ms
    @print = true
    super(graph)
    # берем максимальное количество баров для прорисовки всех индикаторов 365 + 100 = 465
    # @bars = Bar.where( :fund_id => @fund.id,  :frame => @frame ).last(465)
    # добавляем последний бар на остове текущего значения курса
    # @bars << Bar.new(:fund_id => @fund.id,  :frame => @frame, :time => Time.now, :rate => @fund.rate )
    # @lasts = {} # для последних точек, которые не сохраняются в базе
    # init_settings
    # puts "#{@setting.name}: #{Time.now.to_ms - @time} ms" if @print
  end

  def init_settings
    init_bars = @bars
    # init_ticks = @ticks
    settings.each do |set|
      time = Time.now.to_ms if @print
      case set.method
        when 'simple'
          # Service.start(:name => set.name, :fund => @fund.id, :frame => @graph.frame,
          #               :indicator => self.id, :setting => set.id)
        init_sma(init_bars, set.name, set.period)
        puts "#{set.name}: #{Time.now.to_ms - time} ms" if @print
        when 'exponential'
            init_ema(init_bars, set.name, set.period)
          # Service.start(:name => set.name, :fund => @fund.id, :frame => @graph.frame,
          #               :indicator => self.id, :setting => set.id)
          # if !set.frame.nil? && set.frame.name == '1s'
          #   Service.start(:name => set.name, :fund => @fund.id, :frame => @graph.frame,
          #                 :indicator => self.id, :setting => set.id)
          #   # init_ema_ticks(set.name, set.period)
          # else
          #   init_ema(init_bars, set.name, set.period)
          # end
          #
          puts "#{set.name}: #{Time.now.to_ms - time} ms" if @print
      end
    end
  end

  # расчет значения простой скользящей средней
  def calc_sma(period, index, bars)
    sum = 0
    n = 0
    (index+1).upto(index+period) do |i|
      sum += bars[i].rate
      n += 1
    end
    # puts "n: #{n}, bar: #{bars[index+period].time}" if @print
    (sum / period).round(@fund.comma)
  end

  # инициализируем точки для простой скользящей средней
  def init_sma(bars, name, period)
    bars = Bar.pre_add(bars, period)
    puts "bars: #{bars.size}, last: #{bars.last.time}" if @print
    (0).upto(Graph::SIZE-1) do |index| # проходим с начала видимых баров до последней точки
      bar = bars[index+period] # текущий бар соответсвующий точке расчета
      break unless bar # отваливаемся если вдруг не определен бар
      # puts "bar: #{bar.time}" if @print
      point = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                     :name => name, :time => bar.time).first
      if point.nil? # нет точки
        point = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                         :name => name, :time => bar.time, :value => calc_sma(period, index, bars))
        puts "index: #{index}, point: #{point}" if @print
      elsif (index == (Graph::SIZE-1)) # это последняя точка
        point.value = calc_sma(period, index, bars)
        point.save!
      end
    end
  end

  def calc_ema(period, prev_ema, rate)
    alpha = 2.0 / (period + 1)
    value = (prev_ema + alpha * (rate - prev_ema)).round(@fund.comma)
    # if point # точка есть
    #   point.value = value
    #   point.last = last # надо обновить живую точку
    #   point.save
    # else # создаем новую точку
    #   Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
    #                            :name => name, :time => time, :value => value, :last => last)
    # end
  end


  # инициализируем точки для экспонециальной скользящей средней для тиков
  def init_ema_ticks(name, period)
    t1 = @graph.begin_time - (period+1)
    t2 = @graph.end_time
    Command.run(:name => name, :fund => @fund, :frame => @frame, :begin_time => Time.at(t1), :end_time => t2)
    first = Tick.where('fund_id = ? AND time <= ?', @fund.id, Time.at(t1)).last
    puts "first tick: #{first}"
    prev = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                  :name => name, :time => first.time).first
    prev = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                    :name => name, :time => first.time, :value => first.rate) unless prev
    # ticks = Tick.where('fund_id = ? AND time >= ? AND ', @fund.id, Time.at(t1),
    (t1+1).upto(t2) do |t|
      point = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                     :name => name, :time => Time.at(t)).first
      if point.nil? # нет точки
        rate = Tick.where('fund_id = ? AND time <= ?', @fund.id, Time.at(t)).last.rate
        point = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                         :name => name, :time => Time.at(t), :value => calc_ema(period, prev.value, rate))
        puts point if @print
      end
      prev = point
    end
  end

  # инициализируем точки для экспонециальной скользящей для баров
  def init_ema(bars, name, period)
    list = Bar.pre_add(bars, period)
    puts "list: #{list.size}, last: #{bars.last.time}" if @print
    # обязательно нужна первая точка для затравки
    prev = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                  :name => name, :time => list[0].time).first
    prev = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                    :name => name, :time => list[0].time, :value => list[0].rate) unless prev # first init
    (1).upto(list.size-1) do |index| # проходим с конца до начала видимых баров
      item = list[index] # текущий бар соответсвующий точке расчета
      point = Point.where(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                     :name => name, :time => item.time).first
      if point.nil? # нет точки
        point = Point.create!(:indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                                         :name => name, :time => item.time, :value => calc_ema(period, prev.value, item.rate))
        puts "index: #{index}, point: #{point}" if @print
      elsif (index == (bars.size-1)) # это последняя точка
        point.value = calc_ema(period, prev.value, item.rate)
        point.save!
      end
      prev = point
    end
  end

  # def draw
  #   settings.each do |set|
  #     if set.method == 'simple' || set.method == 'exponential'
  #       t1 = @graph.begin_time
  #       t2 = @graph.end_time
  #       points = Point.where('indicator_id = ? AND fund_id = ? AND frame_id = ? AND name = ? AND time >= ? AND time <= ?',
  #                                       self.id, @fund.id, @frame.id, set.name, Time.at(t1), Time.at(t2))
  #       # points = Point.where(:indicator_id => self.id, :fund_id => @fund.id,
  #       #                                 :frame_id => @frame.id, :name => set.name).last(101)
  #       # points << @lasts[set.name]
  #       draw_line(points, set.color, set.line_width, set.line_dash, set.radius)
  #       draw_future_line(points, set.color, set.line_width, set.line_dash)
  #     end
  #   end
  # end

end

# SELLAR
# def init_bars(period)
#   period_time = @bars[0].time - (period * @frame.id)
#   add = Bar.where('fund_id = ? AND frame = ? AND time >= ? AND time < ?', @fund.id, @frame.id,
#                   period_time, @bars.first.time)
#   bars = add + @bars
#   puts "bars: #{bars.size}" if @print
#   bars
# end

