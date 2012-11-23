class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series_lists do |t|
      t.string :name
      t.integer :category_id
      t.attachment :image

      t.timestamps
    end
  end
end
