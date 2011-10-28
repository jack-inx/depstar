class Category < ActiveRecord::Base
  has_many :products  

  self.per_page = 9
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
