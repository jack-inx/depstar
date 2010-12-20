class CreateShippingDetails < ActiveRecord::Migration
  def self.up
    create_table :shipping_details do |t|
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.integer :payment_method_id
      t.string :paypal_email
      t.integer :product_id
      t.boolean :requires_box
      t.integer :question_response_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_details
  end
end
