class Category < ActiveRecord::Base
  USELL_CATEGORY_CODES = ['Cell Phones', 'Tablets', 'MP3 Players', 'Game Consoles', 'E-Readers', 'Digital Cameras']
  
  has_many :products  

  self.per_page = 12
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
