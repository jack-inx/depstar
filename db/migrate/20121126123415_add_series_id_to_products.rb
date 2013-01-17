class AddSeriesIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :series_list_id, :integer
  end
end
