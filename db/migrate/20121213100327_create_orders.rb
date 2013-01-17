class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :state
      t.string :city
      t.string :zip
      t.integer :phone_number
            
      t.timestamps
    end
  end
end
