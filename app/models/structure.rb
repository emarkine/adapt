class Structure < ActiveRecord::Base
  default_scope { order(:position) }
  belongs_to :crystal
  belongs_to :node
  belongs_to :edge


  def to_s
    "Structure[#{id}], crystal: #{crystal.name}, node: #{node.name}, edge: #{edge.name}, position: #{position}"
  end

end
