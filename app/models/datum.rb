class
Datum < ActiveRecord::Base
  default_scope { order(:time) }
  belongs_to :prev, class_name: :Datum, foreign_key: :prev_id
  belongs_to :next, class_name: :Datum, foreign_key: :next_id
  belongs_to :fund
  belongs_to :frame
  belongs_to :neuron


  def to_s(long=false)
    return "Datum[#{id},#{time.strftime('%T')}]" unless long
    s = "Datum[#{id}], "
    s += " fund: #{fund.name}, frame: #{frame.name}, neuron: #{neuron.name}"
    s += " value: #{value}, time: #{time}"
  end

end
