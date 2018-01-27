class CreateStructures < ActiveRecord::Migration[5.1]
  def change
    create_table :structures do |t|
      t.references :crystal, index: true, null: false # к какому кристаллу относится
      t.references :node, index: true, null: false # к какому узлу относится
      t.references :edge, index: true, null: false # к какой грани относится
      # t.integer :position, null: false # место нахождения в кристалле
    end
    add_index(:structures, [:crystal_id, :node_id, :edge_id], :unique => true, :name => 'structures_index')
  end
end
