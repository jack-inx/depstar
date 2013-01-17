class AddManufacturerToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :manufacturer, :string
  end

  def self.down
    remove_column :products, :manufacturer
  end
end
