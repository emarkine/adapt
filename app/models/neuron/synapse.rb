# Служит для передачи нервного импульса между двумя клетками,
# причём в ходе синаптической передачи амплитуда и частота сигнала могут регулироваться.
class Neuron::Synapse < ActiveRecord::Base
  # validates :name, :presence => true, :uniqueness => true
  validates :weight, :presence => true
  validates :prev_id, :presence => true
  validates :next_id, :presence => true
end
