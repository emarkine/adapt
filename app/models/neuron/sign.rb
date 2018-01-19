# входной нейрон знака индикатора
class Neuron::Sign < Neuron::Input

  def title(fund_id)
     case value(fund_id)
       when -1
         ' - '
       when 0
         ' 0 '
       when 1
         ' + '
       else
         ''
     end
   end


end