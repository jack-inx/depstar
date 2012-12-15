class CreateJoinTableForProductsUsersTable < ActiveRecord::Migration
  def up
     create_table :products_users, :id => false do |t|
        t.references :product
        t.references :user        
    end
  end

  def down
    drop_table :products_users
  end
end
