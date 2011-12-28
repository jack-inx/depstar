class AdduSellCategoryCodeToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :usell_category_code, :integer
  end

  def self.down
    remove_column :categories, :usell_category_code
  end
end
