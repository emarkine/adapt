class Neuron::Link < ActiveRecord::Base
  belongs_to :lower, :class_name => 'Neuron', :foreign_key => :lower_id
  belongs_to :upper, :class_name => 'Neuron', :foreign_key => :upper_id
end
