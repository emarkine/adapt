# нейрон вершины грани
class Neuron::Top < Neuron

  # для выходного нейрона сети не может быть нулевого сигнала
  def response(sum, count)
    result = super(sum,count)
    result = 1 if result == 0
    result
  end


end