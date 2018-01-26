class Node < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :name, presence: true
  has_many :edges
  belongs_to :parent, class_name: :Node, foreign_key: :parent_id
  belongs_to :next, class_name: :Node, foreign_key: :next_id
  belongs_to :prev, class_name: :Node, foreign_key: :prev_id
  belongs_to :up, class_name: :Node, foreign_key: :up_id
  belongs_to :down, class_name: :Node, foreign_key: :down_id
  belongs_to :left, class_name: :Node, foreign_key: :left_id
  belongs_to :right, class_name: :Node, foreign_key: :right_id

  def to_s
    "Node[#{id}] #{title}, name: #{name}, edges: #{edges.size}"
  end

end
