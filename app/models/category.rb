class Category < ActiveRecord::Base
  has_many :products  

  self.per_page = 10
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
