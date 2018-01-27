class Crystal < ActiveRecord::Base
  include CrystalsHelper
  has_many :structures
  has_many :nodes, through: :structures
  has_many :edges, through: :structures
  has_many :neurons, through: :edges

  def to_s
    "Crystal[#{id}] #{name}, edges: #{nodes.size}, edges: #{edges.size}, neurons: #{neurons.size}"
  end

  def axis
    edges[0]
  end

  def pulse
    @print = true
    @time = Time.now
    # point = self.setting.point
    # puts point
    # impulse = Neuro::Impulse.create!(:robot => robot,
    #                                  :indicator => indicator,
    #                                  :fund => fund,
    #                                  :frame => frame,
    #                                  :time => Time.now)
    # puts impulse
    # # Перебираем грани кристалла начиная с последней, кроме самой нижней
    self.edges.each do |edge|
      break if edge == edges.last
      edge.pulse  has_many :structures
  has_and_belongs_to_many :crystals, throws: :structures

    end
    # # просчитываем верхнюю грань
    edges.last.neurons.each do |n| # перебираем все нейроны грани
      n.pulse # передаем импульс
    end
    self.level = out.level
    # self.save!
    # Neuro::Pulse.store(impulse, self, out.level)
    puts "#{self} #{Time.now.to_ms - @time.to_ms} ms" if @print
    out.level
  end

  # def pulse(impulse)
  #   @print = false
  #   # Перебираем грани кристалла начиная с последней, кроме самой нижней
  #   self.edges.each do |edge|
  #     break if edge == edges.last
  #     edge.pulse(impulse)
  #   end
  #   # просчитываем верхнюю грань
  #   edges.last.neurons.each do |n| # перебираем все нейроны грани
  #     n.pulse(impulse) # передаем импульс
  #   end
  #   self.level = out.level
  #   self.save!
  #   Neuro::Pulse.store(impulse, self, out.level)
  #   puts self if @print
  #   out.level
  # end

  def out
    neurons.find_by_type 'Neuron::Out'
  end

  def dimension
    %w(level angle trend turn sign edge)
  end

end


# CELLAR
# сохраняем результат работы нейросети
# level = out.level
# level = 1 if level == 0 # выходной сигнал сети не должен быть пустым
# self.level = edges.first.neuron.level
# снимаем напряжение с вершин

# Neuro::Pulse.store(impulse,self.neurons.where(:type => 'Neuro::TopNeuron'))
# self.level = edges.first.gravity(impulse)
# save!

# if impulse.store
#   # neurons.each do |n|
#   #   DataNeuronet.create!(:neuronet_id => self.id, :neuron_id => n.id, :time => impulse.time, :level => n.level)
#   # end
# end
# def datas(fund,begin_time,end_time)
#   self.data_neuronets.where(:fund_id => fund.id)
# end

# выходной нейрон сети
# def out
#   # neurons.order('layer DESC').last
#   edges[-1].last
# end

# def edges
#   ls = []
#   1.upto(neurons.order('layer DESC').first.layer) do |i|
#     ls << neurons.layer(i)
#   end
#   ls
# end

# data = Neuro::DataNeuronet.where(:neuronet_id => self.id, :fund_id => impulse.fund.id, :time => impulse.time).first
# if data # почему-то здесь глучит - дублируются записи
#   data.level = self.level
#   data.save!
# else
#   Neuro::DataNeuronet.create!(:neuronet_id => self.id, :fund_id => impulse.fund.id,
#                               :time => impulse.time, :level => self.level)
# end
# 1.upto(edges.size-1) do |i| # цикл до последнего слоя
#   edges[i].pulse(impulse) # текущий слой
# end
