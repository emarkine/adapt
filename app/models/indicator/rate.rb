# Индикатор текущего курса
class Indicator::Rate < Indicator

  def init(graph)
    @print = true
    super(graph)
  end

  def draw
    super(false)
    # draw_horizontal_line if @graph.separate? && @graph.range
  end


  # различие у углах между послендими нейронами (2-я производная)
  def turn
    d1 = derivative(@points[-2], @points[-1])
    d2 = derivative(@points[-3], @points[-2])
    d3 = derivative(@points[-4], @points[-3])
    if d1 < 0 && d2 > 0 && d3 > 0 # начало разворота
      -9
    elsif d1 < 0 && d2 < 0 && d3 > 0 # продолжаем разворот
      -5
    elsif d1 < 0 && d2 < 0 && d3 < 0 # развернулись
      -1
    else
      0
    end
  end

  # Индикатор получил сигнал от нейросети
  def pulse(impulse)
    time = Time.now.to_ms
    super(impulse)
    # puts "@sign: #{@sign}"
    # puts "@level: #{@level}"
    assign('sign_rate', @sign)
    assign('level_rate', @level)
    assign('turn_rate', turn)
    puts "Indicator[#{name}].pulse: #{Time.now.to_ms - time} ms" if @print
  end

end

__END__

def to_s
  s = "Indicator[#{id}]: #{name}, method: #{@method}, period: #{@period}, frame: #{@frame}"
  s += ", ticks: #{@ticks.size}" if @ticks
  s += ", points: #{@points.size }" if @points
  s += ", #{Time.now.to_ms - @time} ms" if @time
  s
end

def init(graph)
  @print = true
  super(graph)
  puts "Indicator[#{name}].init: #{Time.now.to_ms - @time} ms" if @print
end

# def draw
#   @points['rate'] = @points['rate'].last(100) if @points['rate']
#   super
#   # draw_future_line(@points)
#   # puts self if @print
# end



