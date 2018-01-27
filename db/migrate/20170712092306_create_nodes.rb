class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.string :type
      t.string :title, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.text :text
      t.date :date
      t.time :time
      t.string :file
      t.integer :parent_id    # hierarchy
      t.integer :next_id      # sibling next
      t.integer :prev_id      # sibling prev
      t.integer :x            # space x
      t.integer :left_id      # space x move left
      t.integer :right_id     # space x move right
      t.integer :y            # space y
      t.integer :up_id        # space y move up
      t.integer :down_id      # space y move down
      t.integer :z            # space z
      t.integer :forward_id   # space z move forward
      t.integer :backward_id  # space z move backward
    end
    add_index(:nodes, :title, unique: true, name: :node_title_index)
  end
end
