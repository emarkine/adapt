class CreateEdges < ActiveRecord::Migration[5.1]
  def change
    create_table :edges do |t|
      t.string :name
      t.references :setting, :null => false # связь грани с установкой индикатора
      t.references :node # связь грани с узлом
    end
    add_index(:edges, [:setting_id], :name => 'edges_index', :unique => true)
  end
end
