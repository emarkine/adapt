# http://www.theignatpost.ru/magazine/index.php?mlid=3471
class Indicator::Sar < Indicator

  def init(graph)
    @print = true
    super(graph)
  end


# отрисовка индикатора на графике фонда
  def draw
    # рисуем круглешочки
    if @points['sar']
      @points['sar'].each do |point|
        x = @graph.to_x(point.time, Graph.xx) - 0.5
        y = @graph.to_y(point.value, Graph.yy)
        @graph.list << {name: 'circle', x: x, y: y, lineWidth: @line_width, radius: @radius, :color => @color, :fill => @fill}
      end
      draw_future_line(@points['sar'])
      # if @stop
      #   draw_horizontal_line(@sar)
      # else
      #   draw_future_line(@points, @color, @line_width)
      # end
    end
  end
end

begin
  def init(graph)
    super(graph)
    # @print = true
    @initial_step = @setting.initial_step # начальный фактор ускорения
    @maximum_step = @setting.maximum_step # максимальное значение фактора
    @incremental_step = @setting.incremental_step # шаг ускорения
    @bars = Bar.pre_add(@bars, 10)
    @direction = 1 # call выбирается произвольным образом
    @turn_level = 0
    init_sar
  end

  # инициализация начальных параметров
  def init_params(bar)
    @stop = true # флаг того, что только что произошел разворот
    @acceleration = @initial_step # начальное ускорееие
    @high = bar.high # новый максимум
    @low = bar.low # новый минимум
    if @direction > 0 # call
      @sar = bar.low # начальное значение sar для должно быть внизу для call
    else
      @sar = bar.high # начальное значение sar для должно быть вверху для put
    end
  end

  # увеличение ускорения с проверкой на граничные условия
  def increment_acceleration
    @acceleration += @incremental_step # увеличивааем ускорени
    @acceleration = @acceleration.round(2) # округляем его
    @acceleration = @maximum_step if @acceleration > @maximum_step
    # puts "acceleration: #{@acceleration}" if @print
  end

  # расчет фвктора ускорения с проверкой условий роста
  # https://en.wikipedia.org/wiki/Parabolic_SAR
  def check_acceleration(bar)
    if @direction > 0 # call
      if bar.high > @high # новое максимальное значение
        @high = bar.high
        increment_acceleration
      end
    elsif @direction < 0 # put
      if bar.low < @low # новое минимальное значение
        @low = bar.low
        increment_acceleration
      end
    end
  end

  # идикатор стопа и разворота
  def stop_and_reverse(bar)
    if @direction > 0 # call
      bar.low < @sar # stop and reverse
    elsif @direction < 0 # put
      bar.high > @sar # stop and reverse
    end
  end

  # вычисление sar
  def calc_sar(bar)
    @stop = false # сбрасываем флаг разворота
    check_acceleration(bar)
    if @direction > 0 # call
      @sar = (@sar + (bar.high - @sar) * @acceleration).round(@fund.comma)
    else # put
      @sar = ((bar.low - @sar) * @acceleration + @sar).round(@fund.comma)
    end
    # puts "sar: #{@sar}" if @print
  end

  # расчет sar для всего периода
  def init_sar
    init_params(@bars.first)
    0.upto(@bars.size-1) do |i| # проходим все бары с первого до последнего
      bar = @bars[i]
      point = @points.where(:time => bar.time).first # находим точку
      if point
        @sar = point.rate
      else
        if stop_and_reverse(bar) # только что произошел разворот
          @stop = true
          if @direction > 0 # call
            @direction = -1
            @turn_level = -9 # уровень разворотного нейрона
          else
            @direction = 1
            @turn_level = +9 # уровень разворотного нейрона
          end
          init_params(bar)
        else
          calc_sar(bar)
          if @turn_level > 0 # уменьшаем уровень разворота если он уже не равен 0
            @turn_level -= 1
          elsif @turn_level < 0
            @turn_level += 1
          end

        end
        point = Point.new(:name => 'sar', :indicator_id => self.id, :fund_id => @fund.id,
                          :time => bar.time, :value => @sar)
        @points << point
        # if i >= (@bars.size-3) # последние две точки не заносится в базу
        #   @points << point
        # else
        #   point.save!
        #   # puts "point: #{point.time}"
        # end
      end
    end
  end


  # Индикатор получил сигнал от нейросети
  def pulse(impulse)
    super(impulse)
    puts "\nSAR" if @print
    puts "sign: #{@sign}" if @print
    puts "level: #{@level}" if @print
    puts "turn: #{@turn_level}" if @print
    assign('sign_sar', @direction)
    if @stop # если sar только что переключился, то наклона нет
      assign('level_sar', 0)
    else
      assign('level_sar', @level)
    end
    assign('turn_sar', @turn_level)
    # puts "SarIndicator.pulse(#{Time.now})"
  end

end