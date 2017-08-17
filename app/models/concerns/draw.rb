module Draw
  # include ClassMethods
  #
  # def self.include(base)
  #   base.extend(ClassMethods)
  # end
  #
  # module ClassMethods
  #
  # end

  def draw_init(graph)
    # time = Time.now.to_ms
    # @print = true
    @graph = graph
    @fund = graph.fund
    @bars = graph.bars
    @ticks = graph.ticks
    @frame = graph.frame
    @period = @setting.period if @setting.period
    @method = @setting.method if @setting.method
    @color = @setting.color if @setting.color
    @fill = @setting.fill if @setting.fill
    @line_width = @setting.line_width if @setting.line_width
    @line_dash = @setting.line_dash if @setting.line_dash
    @radius = @setting.radius if @setting.radius
    @points = {}
    init_points
  end

  # линия
  def draw_line(points, color, fill, line_width = @line_width, line_dash = @line_dash, radius = nil)
    return if points.nil? || points.empty?
    # рисуем линию
    points.each_with_index do |point, i|
      # x = @graph.to_x(point.time, Graph.xx)
      # y = @graph.to_y(point.value, Graph.yy)
      x = @graph.to_x(point.time)
      y = @graph.to_y(point.value)
      if i == 0
        @graph.list << {name: 'move', x: x, y: y}
      else
        @graph.list << {name: 'line', x: x, y: y}
      end
    end
    @graph.list << {name: 'plot', width: line_width, color: color, dash: line_dash}
    # рисуем круглешочки
    if !radius.nil? && radius > 0
      points.each do |point|
        x = @graph.to_x(point.time) - 0.5
        y = @graph.to_y(point.value)
        @graph.list << {name: 'circle', x: x, y: y, lineWidth: line_width, radius: radius, color: color, fill: fill }
      end
    end
  end

  # прорисовка лини тренда в будущее
  def draw_future_line(points, color = @color, line_width = @line_width, line_dash = @line_dash)
    a, b = points.last(2) # берем две последние опорные точки
    return if a.nil? || b.nil?
    # raise "No points for trend: #{self}" if a.nil? || b.nil?
    dx = b.time.to_i - a.time.to_i # считаем между ними сдвиг во времени
    dy = b.value.to_f - a.value.to_f # считаем между ними сдвиг в цене
    c_time = @graph.time + @graph.step # точка в будущем
    dx_c = c_time - b.time.to_i # изменение во времени между последей опорной точкой и точкой в будущем
    derivative = dx.to_f / dy # производная
    dy_c = dx_c.to_f / derivative # размер сдивга в цене для будущей точки
    c_rate = b.value.to_f + dy_c # цена в будущем
    x1 = @graph.to_x(b.time)
    y1 = @graph.to_y(b.value)
    x2 = @graph.to_x(c_time)
    y2 = @graph.to_y(c_rate)
    @graph.list << {name: 'line_to', x1: x1, y1: y1, x2: x2, y2: y2, size: line_width, dash: line_dash, color: color}
  end

  # прорисовка горизонтальной линии
  def draw_horizontal_line(rate = 0)
    x1 = @graph.to_x(@graph.begin_time)
    y1 = @graph.to_y(rate)
    x2 = @graph.to_x(@graph.future)
    y2 = @graph.to_y(rate)
    @graph.list << {name: 'line_to', x1: x1, y1: y1, x2: x2, y2: y2, size: @line_width, color: @color, dash: @line_dash}
  end

  # прорисовка горизонтальной линии в будущее
  def draw_future_horizontal_line(rate = 0, color = @color, line_width = @line_width, line_dash = @line_dash)
    x1 = @graph.to_x(@graph.time-5)
    y1 = @graph.to_y(rate)
    x2 = @graph.to_x(@graph.future)
    y2 = @graph.to_y(rate)
    @graph.list << {name: 'line_to', x1: x1, y1: y1, x2: x2, y2: y2, size: line_width, color: color, dash: line_dash}
  end


end  
