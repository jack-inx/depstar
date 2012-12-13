class CreateProductShippingDetailTable < ActiveRecord::Migration
  def up
     create_table :products_shipping_details, :id => false do |t|
        t.references :product
        t.references :shipping_detail
        
    end
    
  end

  def down
    drop_table :products_shipping_details
  end
  
end
