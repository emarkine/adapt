class Neuron::Random < Neuron

  # случайный сигнал в интервале [-9..9]
  def pulse(impulse)
    rnd = 1 + rand(9)
    # Random.new_seed
    sign = (rand(2) == 0) ? -1 : 1
    self.level = rnd * sign
  end


end