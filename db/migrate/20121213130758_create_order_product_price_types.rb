class CreateOrderProductPriceTypes < ActiveRecord::Migration
  def change
    create_table :order_product_price_types do |t|
      t.integer :order_id  
      t.integer :product_id            
      t.integer :price_type_id
      t.timestamps
    end
  end
end
