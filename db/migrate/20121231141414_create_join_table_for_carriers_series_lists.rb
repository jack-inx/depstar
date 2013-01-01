class CreateJoinTableForCarriersSeriesLists < ActiveRecord::Migration
  def up
     create_table :carriers_series_lists, :id => false do |t|
      t.integer :carrier_id
      t.integer :series_list_id
    end
  end

  def down
    drop_table :carriers_series_lists
  end
end
