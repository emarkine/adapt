# нерв связывающий два нейрона
class Nerve < ActiveRecord::Base
  belongs_to :node, foreign_key: :node_id, class_name: :Node
  belongs_to :source, foreign_key: :source_id, class_name: :Neuron
  belongs_to :recipient, foreign_key: :recipient_id, class_name: :Neuron

  def to_s
    "Nerve[#{id}] (#{node.name})  #{source.name} -> #{recipient.name}, value: #{value}, level: #{level}"
  end

end
