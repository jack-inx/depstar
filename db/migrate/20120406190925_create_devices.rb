class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.integer :shipping_detail_id
      t.integer :product_id
      t.integer :question_response_id
      t.float :final_offer
      t.integer :status_code
      t.string :notes
      t.text :serial
      t.float :offer

      t.timestamps
    end
  end

  def self.down
    drop_table :devices
  end
end
