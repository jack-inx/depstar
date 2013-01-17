class AddColumnValueToProducts < ActiveRecord::Migration
    add_column :products, :value, :float
  def self.up
  end

  def self.down
    remove_column :products, :value    
  end
end
