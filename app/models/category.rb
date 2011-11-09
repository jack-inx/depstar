class Category < ActiveRecord::Base
  has_many :products  

  self.per_page = 12
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
