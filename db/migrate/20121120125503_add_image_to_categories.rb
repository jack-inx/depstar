class AddImageToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :photo_file_name, :string
    add_column :categories, :photo_content_type, :string
    add_column :categories, :photo_file_size, :integer
    add_column :categories, :photo_updated_at, :datetime
  end
  def self.down
    add_column :categories, :photo_file_name, :string
    add_column :categories, :photo_content_type, :string
    add_column :categories, :photo_file_size, :integer
    add_column :categories, :photo_updated_at, :datetime
  end
end
