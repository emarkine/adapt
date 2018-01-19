class Indicator::IPoint < Indicator

  attr_accessor :set

  def init(graph)
    super(graph)
    @min = -10
    @max = 10
    @range = 20
  end

  def init_points
    if (set)
      @points = {}
      # @points['level'] = []
      @points['angle'] = []
      # @points['trend'] = []
      # @points['turn'] = []
      # @points['sign'] = []
      setting = Setting.find_by_name set
      points = Point.where('fund_id = ? AND setting_id = ? AND time >= ? AND time <= ?',
                                      @fund.id, setting.id, Time.at(@graph.begin_time), Time.at(@graph.end_time))
      points.each do |p|
        # @points['level'] << Point.init( 'level', p.level, p)
        @points['angle'] << Point.init( 'angle', p.angle, p)
        # @points['trend'] << Point.init( 'trend', p.trend, p)
        # @points['turn'] << Point.init( 'turn', p.turn, p)
      end
    end
  end

  def draw
    if set
      super
      # draw_horizontal_line(0)
    end
  end


end
