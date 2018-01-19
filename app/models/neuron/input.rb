# входной нейрон
class Neuron::Input < Neuron

  def point
    Point.where(setting: self.edge.setting).last
  end

end