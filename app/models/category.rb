class Category < ActiveRecord::Base
  has_many :products
  has_many :question_options
  accepts_nested_attributes_for :question_options, :allow_destroy => true
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
