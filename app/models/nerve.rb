# нерв связывающий два нейрона
class Nerve < ActiveRecord::Base
  belongs_to :node, foreign_key: :node_id, class_name: :Neuron
  belongs_to :source, foreign_key: :source_id, class_name: :Neuron
  belongs_to :recipient, foreign_key: :recipient_id, class_name: :Neuron
  # belongs_to :fund
  # belongs_to :frame

  def to_s
    s = "Nerve[#{id}] (#{node.name})  #{source.name} -> #{recipient.name}, value: #{value}, level: #{level}"
    s += ", fund: #{fund.name}" if fund
    s += ", frame: #{frame.name}" if frame
    s
    #
    # if long
    #   "Nerve[#{id}], source: (#{source}), recipient: (#{recipient}), fund: #{fund.name}, frame: #{frame.name}"
    # else
    #   "Nerve[#{id}] #{source.name} -> #{recipient.name}"
    # end
  end

end
