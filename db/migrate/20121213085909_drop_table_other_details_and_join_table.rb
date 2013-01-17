class DropTableOtherDetailsAndJoinTable < ActiveRecord::Migration
  def up
    drop_table :products_shipping_details
    drop_table :other_details
  end

  def down
    create_table :products_shipping_details, :id => false do |t|
        t.references :product
        t.references :shipping_detail        
    end
    
    create_table :other_details do |t|
      t.references :shipping_detail
      t.integer :product_id
      t.string :price_type, :default=>""
      t.timestamps
    end
  end
end
