class CreateEdges < ActiveRecord::Migration[5.1]
  def change
    create_table :edges do |t|
      t.string :name, null: false
      t.references :setting, :null => false # связь грани с установкой индикатора
    end
    add_index(:edges, [:setting_id], :name => 'edges_index', :unique => true)
  end
end
