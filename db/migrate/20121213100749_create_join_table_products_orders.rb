class CreateJoinTableProductsOrders < ActiveRecord::Migration
  def up
    create_table :orders_products, :id => false do |t|
        t.references :product
        t.references :order        
    end
  end

  def down
      drop_table :orders_products
  end
end
