class AddColumnIsPopularToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :is_popular, :boolean
  end

  def self.down
    remove_colum :products, :is_popular, :boolean
  end
end
