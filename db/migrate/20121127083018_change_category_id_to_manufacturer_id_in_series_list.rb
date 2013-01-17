class ChangeCategoryIdToManufacturerIdInSeriesList < ActiveRecord::Migration
  def up   
    add_column :series_lists, :manufacturer_id, :integer
  end

  def down    
    remove_column :series_lists, :manufacturer_id
  end
end
