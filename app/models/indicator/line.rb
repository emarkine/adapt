class Indicator::Line < Indicator

  def init(graph)
    @print = true
    super(graph)
  end

  def init_point(name)
    set = settings.find_by_name name
    point = Point.where(setting: set, fund: @fund).last
    return unless point
    return if point.time.to_date != Time.at(@graph.end_time).to_date
    @points[set.name] = point
  end

  def init_points
    @points = {}
    init_point 'line_previous_close'
    init_point 'line_opening_price'
  end

  # прорисовка индикатора
  def draw(future = true)
    settings.reverse_each do |set| # обратный проход нужен для того, чтобы менее важная установка рисовалась последней
      next unless set.color || set.color_high # цвет не задан - ничего не рисуем
      if @points[set.name]
        point = @points[set.name]
        y = @graph.to_y(point.value)
        @graph.list << {name: 'move', x: 0, y: y}
        @graph.list << {name: 'line', x: Graph::X, y: y}
        @graph.list << {name: 'plot', width: set.line_width, dash: set.line_dash, color: set.color }
      end
    end
  end


end