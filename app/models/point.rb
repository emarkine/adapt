class Point < ActiveRecord::Base
  default_scope { order('time' ) }
  belongs_to :prev, class_name: :Point, foreign_key: :prev_id
  belongs_to :next, class_name: :Point, foreign_key: :next_id
  belongs_to :setting
  belongs_to :fund
  belongs_to :frame
  belongs_to :service

  validates :setting_id, :fund_id, :time, :value, :presence => true

  def to_s(long=false)
    return "Point[#{id},#{time.strftime('%T')}]" unless long
    s = "Point[#{id}] "
    s += " setting: #{setting.name}, fund: #{fund.name}, frame: #{frame.name}, value: #{value}"
    s += ", service: #{service.name}" if service
    s += ", time: #{Time.at(time)}"
  end

  def self.init(name, value, src)
    point = Point.new
    # point.name = name
    point.value = value
    point.time = src.time
    point.setting_id = src.setting_id
    point.fund_id = src.fund_id
    point.frame_id = src.frame_id
    point.service_id = src.service_id
    point
  end

end

# sellar
