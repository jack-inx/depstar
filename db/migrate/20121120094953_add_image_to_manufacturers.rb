class AddImageToManufacturers < ActiveRecord::Migration
 def self.up
    add_column :manufacturers, :photo_file_name, :string
    add_column :manufacturers, :photo_content_type, :string
    add_column :manufacturers, :photo_file_size, :integer
    add_column :manufacturers, :photo_updated_at, :datetime
  end
   def self.down
    add_column :manufacturers, :photo_file_name, :string
    add_column :manufacturers, :photo_content_type, :string
    add_column :manufacturers, :photo_file_size, :integer
    add_column :manufacturers, :photo_updated_at, :datetime
  end
end
