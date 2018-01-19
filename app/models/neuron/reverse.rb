# входной нейрон показателя разворота
class Neuron::Reverse < Neuron::Input

  def title(fund_id)
    "turn: #{value(fund_id)}"
  end

end