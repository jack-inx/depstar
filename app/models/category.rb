class Category < ActiveRecord::Base
  has_many :products  
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
