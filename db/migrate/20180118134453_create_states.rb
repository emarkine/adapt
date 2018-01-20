class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      # t.string :name
      t.reference :host
      # t.reference :user
      # t.reference :fund
      t.reference :service
      t.string status
      t.timestamps
    end
  end
end
