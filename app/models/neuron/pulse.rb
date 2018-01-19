class Neuron::Pulse < ActiveRecord::Base
  default_scope { order(:time) }
  scope :graph, ->(graph) { where('fund_id = ? AND time >= ? AND time < ?',
                                  graph.fund.id, Time.at(graph.begin_time), Time.at(graph.end_time)) }
  # belongs_to :object, polymorphic: true
  belongs_to :robot, :class_name => 'Robot::Robot'
  belongs_to :crystal, :class_name => 'Neuro::Crystal'
  belongs_to :neuron, :class_name => 'Neuro::Neuron'
  belongs_to :fund
  validates :fund_id, :time, :level, :presence => true


  def after_initialize
    @print = false
  end

  def self.store(impulse, object, level)
    level = 0 if level.nil?
    case object.class.name
      # when 'Robot::Robot', 'Robot::TredaRobot', 'Robot::BollisaRobot', 'Robot::NuraRobot', 'Robot::MilaRobot'
      #   pulse = Pulse.where(:robot_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time).first
      #   pulse = Pulse.create!(:robot_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time, :level => object.level) unless pulse
      when 'Indicator::Indicator'
        pulse = Neuro::Pulse.where(:indicator_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time).first
        pulse = Neuro::Pulse.create!(:indicator_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time, :level => level) unless pulse
      when 'Neuro::Crystal'
        pulse = Neuro::Pulse.where(:crystal_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time).first
        pulse = Neuro::Pulse.create!(:crystal_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time, :level => level) unless pulse
      when 'Neuro::Edge'
        pulse = Neuro::Pulse.where(:edge_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time).first
        pulse = Neuro::Pulse.create!(:edge_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time, :level => level) unless pulse
      when 'Neuro::Neuron', 'Neuro::TopNeuron', 'Neuro::SignNeuron', 'Neuro::LevelNeuron'
        pulse = Neuro::Pulse.where(:neuron_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time).first
        pulse = Neuro::Pulse.create!(:neuron_id => object.id, :fund_id => impulse.fund.id, :time => impulse.time, :level => level) unless pulse
      else
        raise "Unknown class: #{object.class}"
    end
    # object.level = level
    # object.save!
    # puts "Pulse.store(#{impulse}, #{object})"
    pulse.level
  end


  def draw(graph)
    x = graph.to_x(self.time)
    color = Neuro::Neuron::COLORS[self.level.abs]
    color = Neuro::Neuron::ZERO_COLOR if self.level == 0
    graph.list << {:name => 'line_to', :x1 => x, :y1 => 0, :x2 => x, :y2 => 10, :color => color}
  end

  def to_s
    "#{Time.at(time)} #{level}"
  end

end
