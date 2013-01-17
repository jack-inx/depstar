class AddNotesToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :notes, :string
  end

  def self.down
    remove_column :shipping_details, :notes
  end
end
