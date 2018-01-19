class Neuron::Impulse < ActiveRecord::Base
  belongs_to :crystal
  # belongs_to :indicator
  # belongs_to :fund
  # belongs_to :frame

  attr_accessor :graph

  validates :crystal_id, :indicator_id, :fund_id, :frame_id, :time, :presence => true

  def to_s
    # "#{time.strftime('%H:%M:%S')} Impulse[#{id}], robot: #{robot.name}, broker: #{broker.name}, fund: #{fund.name}, frame: #{frame.name}"
    "Impulse[#{time.strftime('%H:%M:%S')}]: #{crystal} #{indicator} #{frame} #{fund}"
  end

end
