class CreateStatesForUs < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :state
      t.string :state_code
      
      t.timestamps
    end
  end
end
