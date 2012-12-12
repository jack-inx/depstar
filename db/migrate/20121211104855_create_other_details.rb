class CreateOtherDetails < ActiveRecord::Migration
  def change
    create_table :other_details do |t|
      t.references :shipping_detail
      t.integer :product_id
      t.string :price_type, :default=>""

      t.timestamps
    end
  end
end
