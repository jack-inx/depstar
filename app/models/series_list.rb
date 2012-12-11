class SeriesList < ActiveRecord::Base
  attr_accessible :name, :manufacturer_id, :category_id
  
  belongs_to :manufacturer
  belongs_to :category
  
  has_many :products, :dependent => :destroy
  
end
