class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.string :type
      t.string :title, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.string :file
      # t.text :text
      # t.date :date
      # t.time :time
      # t.integer :x            # space x
      # t.integer :y            # space y
      # t.integer :z            # space z
    end
    add_index(:nodes, :title, unique: true, name: :node_title_index)

    # create_table :nodes_nodes do |t|
    #   t.integer :parent    # hierarchy
    #   t.integer :next      # sibling next
    #   t.integer :prev      # sibling prev
    #   t.integer :left      # space x move left
    #   t.integer :right     # space x move right
    #   t.integer :up        # space y move up
    #   t.integer :down      # space y move down
    #   t.integer :forward   # space z move forward
    #   t.integer :backward  # space z move backward
    # end
  end

end
