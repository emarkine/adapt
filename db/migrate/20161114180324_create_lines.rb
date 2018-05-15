class CreateLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.references :node, null: false # neuro node
      t.references :source, null: false # neuron source of signal
      t.references :target, null: false # neuron target of signal
      t.integer :value, default: 1 # sensitivity of the connection [-9..0..9] it is possible to change the sign of the signal
      t.integer :level, default: 0 # threshold of operation of the neuron [0..10], 0 - everything passes, 10 - everything is closed
    end
    # two neurons can have only one directed line connection in one nerve node
    # add_index(:lines, [:node_id, :source_id, :target_id], unique: true, name: :lines_index)
  end
end