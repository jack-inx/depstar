class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.references :user
      t.references :product
      t.integer :broken_price
      t.integer :used_price
      
      t.timestamps
    end
  end
end
