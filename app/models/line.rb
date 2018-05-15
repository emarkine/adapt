class Line < ApplicationRecord
  belongs_to :node
  belongs_to :source, foreign_key: :source_id, class_name: :Neuron
  belongs_to :target, foreign_key: :target_id, class_name: :Neuron

  def to_s
    "Line[#{id}] node: #{name}, source: #{source}, target: #{target}, value: #{value}, level: #{level}"
  end

  def name
    "#{node.name if node}.#{source.name if source}.#{target.name if target}"
  end

end
