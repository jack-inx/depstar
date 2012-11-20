class Category < ActiveRecord::Base
  USELL_CATEGORY_CODES = ['Cell Phones', 'Tablets', 'MP3 Players', 'Game Consoles', 'E-Readers', 'Digital Cameras']
  
  has_many :products
  has_and_belongs_to_many :manufacturers
  
  attr_accessor :photo_file_name
  attr_accessor :photo_content_type
  attr_accessor :photo_file_size
  attr_accessor :photo_updated_at

  has_attached_file :photo,
                  :default_url => "http://depstar.com/assets/:class/missing_:style.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                  #:url  => "http://depstar.com/assets/products/:id/:style/:basename.:extension",
                  :url  => "http://localhost:3000/assets/categories/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/categories/:id/:style/:basename.:extension"

  self.per_page = 12
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
