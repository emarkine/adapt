class Indicator::Trend < Indicator

  # def init(graph)
  #   super(graph)
  #   # @init_ticks = false
  #   # @print = true
  #   # @points_bar_high = @points.find_by_name 'bar_high'
  #   # @points_bar_low = @points.find_by_name 'bar_low'
  #   # @points_tick_high = @points.find_by_name 'tick_high'
  #   # @points_tick_low = @points.find_by_name 'tick_low'
  #   # @points = []
  #   @fund_setting = settings.find_by_name graph.fund.name
  #   @fund_setting = settings.find_by_name 'default' unless @fund_setting
  #
  #   # init_last_tick(@fund_setting.last_depth, true)
  #   # init_last_tick(@fund_setting.last_depth, false)
  #   # init_ticks(@fund_setting.depth) if @init_ticks
  # end

  # проверка на существование точки, если ее нет - то создаем
  def check_point(name, time, rate, level)
    point = @points.where(:name => name, :fund_id => @fund.id, :frame_id => @frame.id,  :time => time).first
    return point if point # точка найдена
    Indicator::IPoint.create(:name => name, :indicator_id => self.id, :fund_id => @fund.id, :frame_id => @frame.id,
                          :time => time, :value => rate, :level => level)
  end

  # def init_points
  #   # init_bars(@fund_setting.level)
  # end

  # инициализация точек на основе баров
  def init_bars(level)
    (@bars.size-3).downto(1) do |i| # проходим в обратном порядке исключая последний бар
      bar = @bars[i]
      bar_prev = @bars[i-1]
      bar_next = @bars[i+1]
      if  bar_prev && bar_next # только если бары связаны
        if bar.high > bar_prev.high && bar.high > bar_next.high # верхняя точка
          point = check_point('bar_high', bar.time, bar.high, level)
          return if point.id # если точка в базе, то вываливаемся
          point.save!
        end
        if bar.low < bar_prev.low && bar.low < bar_next.low # нижняя точка
          point = check_point('bar_low', bar.time, bar.low, level)
          return if point.id # если точка в базе, то вываливаемся
          point.save!
        end
      end
    end
  end

  # последняя точка считается особым образом и не сохраняется в базе
  def init_last_bar(level,high)
    (@bars.size-2).downto(1) do |i| # проходим в обратном порядке исключая последний бар
      bar = @bars[i]
      bar_prev = @bars[i-1]
      bar_next = @bars[i+1]
      if  bar_prev && bar_next # только если бары связаны
        if high && bar.high > bar_prev.high && bar.high >= bar_next.high # верхняя точка
          return check_point('bar_high', bar.time, bar.high, level)
        end
        if !high && bar.low < bar_prev.low && bar.low <= bar_next.low # нижняя точка
          return check_point('bar_low', bar.time, bar.low, level)
        end
      end
    end
  end

  # проверка условия для трех точек
  def check(n, shift, high)
    tick = @ticks[n]
    left = @ticks[n - shift]
    right = @ticks[n + shift]
    if high # условие роста
      # puts "size: #{@ticks.size}, n: #{n}, shift: #{shift}, high: #{high}" if tick.nil? || left.nil? || right.nil?
      # if shift == 1 # соседний тик
      #   tick.rate >= left.rate && tick.rate >= right.rate
      # else
      tick.rate > left.rate && tick.rate > right.rate
      # end
    else # условие падения
      # if shift == 1 # соседний тик
      #   tick.rate <= left.rate && tick.rate <= right.rate
      # else
      tick.rate < left.rate && tick.rate < right.rate
      # end
    end
  end

  # проверка условия последовательного роста/падения
  def condition(n, depth, high)
    1.upto(depth) do |shift| # идем в глубину
      return false unless check(n, shift, high) # условие не выполнено
    end
    true # все точки соответсвуют условию
  end

  # инициализация точек на основе тиков
  # depth - глубина проверки
  def init_ticks(depth)
    puts "TrendIndicator.init_ticks(#{depth})" if @print
    (@ticks.size-depth-1).downto(depth) do |n| # проходим по всем тикам в обратном порядке
      tick = @ticks[n]
      if condition(n, depth, true) # проверяем на верхнию точку
        point = check_point('tick_high', tick.time, tick.rate, depth)
        return if point.id # если точка в базе, то вываливаемся
        point.save!
      elsif condition(n, depth, false) # проверяем на нижнию точку
        point = check_point('tick_low', tick.time, tick.rate, depth)
        return if point.id # если точка в базе, то вываливаемся
        point.save!
      end
    end
  end

  # добавление точки в массив без сохранения
  def add_point(name,tick,level)
      Indicator::IPoint.new(:name => name, :indicator_id => self.id, :fund_id => @fund.id,
                            :time => tick.time, :value => tick.rate, :level => level)
  end

  # находим опорные точки для последних тиков, для этого достаточно минимального разворота
  def init_last_tick(last_depth, high)
    puts "TrendIndicator.init_last_tick(#{last_depth}, #{high})" if @print
    (@ticks.size-last_depth-1).downto(last_depth) do |n| # проходим по тикам начиная с конца
      if condition(n, 1, high) # нашли точку
        if high
          return add_point('tick_high',@ticks[n],last_depth)
        else
          return add_point('tick_low',@ticks[n],last_depth)
        end
      end
    end
  end


  def bars_high
    points = @points.where(:name => 'bar_high', :fund_id => @fund.id, :frame_id => @frame.id)
    last = init_last_bar(@fund_setting.level, true)
    points << last if !last.nil? && last.id.nil?
    points
  end

  def bars_low
    points = @points.where(:name => 'bar_low', :fund_id => @fund.id, :frame_id => @frame.id)
    last = init_last_bar(@fund_setting.level, false)
    points << last if !last.nil? && last.id.nil?
    points
  end

  def ticks_high
    points = @points.where(:name => 'tick_high', :fund_id => @fund.id, :frame_id => @frame.id)
    points << init_last_tick(@fund_setting.last_depth, true)
    points
  end

  def ticks_low
    points = @points.where(:name => 'tick_low', :fund_id => @fund.id, :frame_id => @frame.id)
    points << init_last_tick(@fund_setting.last_depth, false)
    points
  end

  # отрисовка индикатора на графике фонда

  def draw_
    # puts "TrendIndicator.draw" if @print
    draw_by_name(bars_high,'bar_high')
    draw_by_name(bars_low,'bar_low')
    # draw_by_name(ticks_high,'tick_high')
    # draw_by_name(ticks_low,'tick_low')
    # stg = settings.find_by_name 'bar_low'
    # draw_line(@points.where(:name => 'bar_low'), stg.color, stg.line_width, stg.radius, Graph.xx, Graph.yy)
    # @list << draw_future_line(@points.where(:name => 'bar_low'), @graph.step, stg.color, stg.line_width)
    # stg = settings.find_by_name 'tick_high'
    # draw_line(@points_tick_high, stg.color, stg.line_width, stg.radius, Graph.xx, Graph.yy)
    # @list << draw_future_line(@points_tick_high, @graph.step, stg.color, stg.line_width)
    # stg = settings.find_by_name 'tick_low'
    # draw_line(@points_tick_low, stg.color, stg.line_width, stg.radius, Graph.xx, Graph.yy)
    # @list << draw_future_line(@points_tick_low, @graph.step, stg.color, stg.line_width)
    # draw_in(@points_tick_high, @points_tick_low, Graph.xx, Graph.yy, 3, 0.5)
    # @list << draw_future_line(@points_low, @deal.time_shift, '#f44')
    # @list << draw_future_line(@points_high, @graph.step, '#0c0')
    # @list << draw_future_line(@points_low, @graph.step, '#f44')
  end

  def draw_by_name(points, name)
    stg = settings.find_by_name name
    draw_one_line(points, stg.color, stg.line_width, stg.line_dash, stg.radius)
    draw_future_line(points, stg.color, stg.line_width, stg.line_dash)
  end

  def draw_one_line(points, color, line_width, line_dash,  radius)
    return if points.empty?
    # линия
    # points.each_with_index do |point, i|
    #   x = @graph.to_x(point.time, Graph.xx)
    #   y = @graph.to_y(point.rate, Graph.yy)
    #   if i == 0
    #     @list << {name: 'move', x: x, y: y}
    #   else
    #     @list << {name: 'line', x: x, y: y}
    #   end
    # end
    # @list << {name: 'plot', width: line_width, :color => color}
    draw_line(points, color, line_width, line_dash,  radius)
    # рисуем круглешочки
    points.each do |point|
      # puts point if point.id.nil? && @print
      x = @graph.to_x(point.time, Graph.xx)
      y = @graph.to_y(point.value, Graph.yy)
      @graph.list << {name: 'circle', x: x, y: y, lineWidth: line_width, radius: radius, :color => color, :fill => '#fff'}
    end
  end




  # Индикатор получил сигнал от нейросети
  def pulse(impulse)
    # puts self.class.name
    high_level_bar, high_sign_bar = level(angle(bars_high))
    low_level_bar, low_sign_bar = level(angle(bars_low))
    high_level_tick, high_sign_tick = level(angle(ticks_high))
    low_level_tick, low_sign_tick = level(angle(ticks_low))
    assign('sign_trend_high', high_sign_bar)
    assign('level_trend_high', high_level_bar)
    assign('sign_trend_low', low_sign_bar)
    assign('level_trend_low', low_level_bar)

    assign('sign_trend_tick_high', high_sign_tick)
    assign('level_trend_tick_high', high_level_tick)
    assign('sign_trend_tick_low', low_sign_tick)
    assign('level_trend_tick_low', low_level_tick)
  end

end


# Подвал
# дополнительная фильтрация точек по алгоритму Томас Демарка (TD)
# цена закрытия точек через одну от опорной должна быть тоже ниже ее максимума (?)
# тем самым уменьшается число опорных точек
# def filter
#   @points.select do |point|
#     bar = point[:bar]
#     after = bar.next.next # точка на два бара впереди опорной
#     before = bar.prev.prev # точка на два бара сзади опорной (если она есть)
#     case point[:type]
#       when 'high'
#         if after
#           point if bar.max > before.close && (after && bar.max > after.close)
#         else
#           point if bar.max > before.close && bar.max > bar.next.close
#         end
#       when 'low'
#         if after
#           point if bar.min < before.close && (after && bar.min < after.close)
#         else
#           point if bar.min < before.close && bar.min < bar.next.close
#         end
#     end
#   end
# end

# проверка условия для двух точек
# def check(index,high)
#   a = @ticks[index]
#   b = @ticks[index+1]
#   if high # условие роста
#     b.rate > a.rate
#   else # условие падения
#     b.rate < a.rate
#   end
# end
#
# # проверка условия последовательного роста/падения
# def condition(n, depth, high)
#   left_point = n - depth
#   right_point = n + depth
#   left_point.upto(n-1) do |i| # проходим по точкам от левой до проверочной
#     return false unless check(i,high)
#   end
#   n.upto(right_point-1) do |i| # проходим по точкам от проверочной до правой
#     return false unless check(i,!high) # условие меняется на противоположенное
#   end
#   true
# end
#
# # инициализация точек на основе тиков
# # depth - глубина проверки
# def init_ticks(depth)
#   depth.upto(@ticks.size-depth) do |n| # проходим по всем тикам
#     if condition(n,depth,true)# проверяем на верхнию точку
#       @points << {type: 'high', level: depth, rate: @ticks[n].rate.to_f, time: @ticks[n].time.to_i}
#     elsif condition(n,depth,false)# проверяем на нижнию точку
#       @points << {type: 'low', level: depth, rate: @ticks[n].rate.to_f, time: @ticks[n].time.to_i}
#     end
#   end
# end
# def draw_in(points_high, points_low, color_high, color_low, line_width_, radius, width, height, , xs)
#   # рисуем круглешочки
#   @points.each do |point|
#     # bar = point[:bar]
#     point[:x] = @graph.to_x(point[:time], width)-xs
#     case point[:type]
#       when 'high'
#         point[:y] = @graph.to_y(point[:rate], height)
#         @list << {name: 'circle', x: point[:x], y: point[:y],
#                   lineWidth: 0.5, radius: radius, :color => '#0c0', :fill => '#fff'}
#       when 'low'
#         point[:y] = @graph.to_y(point[:rate], height)
#         @list << {name: 'circle', x: point[:x], y: point[:y],
#                   lineWidth: 0.5, radius: radius, :color => '#f44', :fill => '#fff'}
#     end
#   end
#   # верхняя линия
#   @points_high.each_with_index do |point, i|
#     if i == 0
#       @list << {name: 'move', x: point[:x], y: point[:y]}
#     else
#       @list << {name: 'line', x: point[:x], y: point[:y]}
#     end
#   end
#   @list << {name: 'plot', width: 1, :color => '#0c0'}
#   # нижняя линия
#   @points_low.each_with_index do |point, i|
#     if i == 0
#       @list << {name: 'move', x: point[:x], y: point[:y]}
#     else
#       @list << {name: 'line', x: point[:x], y: point[:y]}
#     end
#   end
#   @list << {name: 'plot', width: 1, :color => '#f44'}
# end
