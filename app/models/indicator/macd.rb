# https://ru.wikipedia.org/wiki/%D0%98%D0%BD%D0%B4%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80_MACD
# http://www.theignatpost.ru/magazine/index.php?mlid=6997
class Indicator::Macd < Indicator

  def init(graph)
    super(graph)
  end

  # def draw
  #   # надо поменять последовательность наборов точек
  #   # first = settings.first
  #   # settings.first = settings.last
  #   @settings = settings.order_by :id
  #   super
  #   # points = @points['macd_chart']
  # end


end