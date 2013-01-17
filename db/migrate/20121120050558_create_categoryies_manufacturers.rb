class CreateCategoryiesManufacturers < ActiveRecord::Migration
  def up
  	create_table :categories_manufacturers, :id => false do |t|
      t.integer :category_id
      t.integer :manufacturer_id
    end
  end

  def down
  	drop_table :categories_manufacturers
  end
end
