class Neuron::Sum < Neuron

  def pulse(layer)
    # super(layer) # просто печать списка значимых связей
    case self.lowers.size
      when 1 # интегрируем в интервал -9 0 9 один логический нейрон
        level = self.lowers[0].level
        if level == 1
          9
        elsif level == -1
          -9
        elsif level == 0
          0
        else # что-то не так с этим нейроном
          10
        end
      when 2 # интегрируем в интервал -9 -5 0 5 9 две логических нейрона
        one = self.lowers[0].level
        two = self.lowers[1].level
        if one == -1 && two == -1
          -9
        elsif (one == -1 && two == 0) || (one == 0 && two == -1)
          -5
        elsif (one == 0 && two == 0) || (one == -1 && two == 1) || (one == 1 && two == -1)
          0
        elsif (one == 1 && two == 0) || (one == 0 && two == 1)
          5
        elsif one == 1 && two == 1
          9
        else # ошибка
          10
        end
      else # что-то не так с этим нейроном
        10
    end
  end


end