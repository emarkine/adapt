class Edge < ActiveRecord::Base
  default_scope { order(:position) }
  include Draw
  belongs_to :setting
  belongs_to :node
  # belongs_to :node_neuro, class_name: 'Node::Neuro'
  has_many :neurons
  has_many :structures
  has_many :nodes, through: :structures
  has_many :crystals, through: :structures

  def self.find_by_name(name)
    setting = Setting.find_by_name name
    raise 'No setting: ' + name unless setting
    Edge.find_by_setting_id setting.id
  end

  def to_s
    "Edge[#{id}], setting: #{setting.name}, neurons: #{neurons.size}"
  end

  def name
    self.setting.name
  end

  def neuron(name)
    index = Neuron::NAMES.index(name)
    type = Neuron::TYPES[index]
    Neuron.find_by(edge: self, type: type)
  end

  def out
    self.neurons[0]
  end

  def angle
    neuron 'angle'
  end

  def trend
    neuron 'trend'
  end

  def reverse
    neuron 'reverse'
  end

  def level
    neuron 'level'
  end

  def sign
    neuron 'sign'
  end

  def init(graph)
    @setting = setting
    draw_init(graph)
    @graph.min = -10
    @graph.max = 10
    @graph.range = 20
    @color = 'black'
    @line_width = 0.2
    @line_dash = 0
  end


  def ps(neuron)
    len = Datum.where('neuron_id = ? AND fund_id = ? ', neuron.id, @graph.fund.id).size
    return [] if len == 0
    t1 = @graph.begin_time - @graph.frame.id * 5
    t2 = @graph.end_time + @graph.frame.id
    Datum.where('neuron_id = ? AND fund_id = ? AND time >= ? AND time <= ?',
                neuron.id, @graph.fund.id, Time.at(t1), Time.at(t2))
  end

  # точки по которым рисуется кривая
  def init_points
    self.neurons.each do |neuron|
      @points[neuron.name] = ps(neuron)
    end
  end

  # прорисовка грани
  def draw(future = true)
    @graph.draw_rate_grid(10, false)
    # draw_horizontal_line(0)
    self.neurons.each do |neuron|
      if @points[neuron.name].size > 0
        draw_line(@points[neuron.name], NeuronsController.helpers.title_color(neuron), 'white', 1)
        draw_future_horizontal_line(@points[neuron.name].last.value, NeuronsController.helpers.title_color(neuron), 0.5)
        # draw_future_line(@points[neuron.name], NeuronsController.helpers.title_color(neuron), 1)
      end
    end
  end

  # назначить всем нейронам определенного типа значение
  def assign_all(name, value)
    neurons.where(:name => name).each do |n|
      n.level = value
      n.save!
    end
  end

  # назначить всем нейронам определенного типа значение
  def assign_item(name, value)
    n = neurons.where(:name => name).first
    n.level = value
    n.save!
  end

  # назначить всем нейронам определенного типа значение
  def assign(point)
    assign_item("#{set.name}_angle", point.angle)
    assign_item("#{set.name}_trend", point.trend)
    assign_item("#{set.name}_turn", point.turn)
    assign_item("#{set.name}_sign", point.sign)
  end

  def pulse
    neurons.each do |n|
      n.pulse
    end
  end

  def pulse_(point = nil)
    @print = crystal.print
    assign(point) if point
    sum = 0
    total_weight = 0.0 # значимость всех нейронов
    self.neurons.reverse_each do |n| # перебираем все нейроны слоя начиная          с последнего
      break if n == neuron # отваливаемся, если дошли до выходного нейрона
      total_weight += n.weight # увиеличиваем силу притяжения
      level = n.pulse
      sum += level * n.weight # передаем импульс
    end
    neuron.level = sum / total_weight # выходной нейрон для грани
    neuron.save!
    if point
      point.level = neuron.level
      point.save!
    end
    puts "\n #{self}\n\n" if @print
    neuron.level
  end

end

# self.level = neurons.inject(0.0) do |sum, n| # проходим по всем детям
