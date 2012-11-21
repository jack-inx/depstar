class Carrier < ActiveRecord::Base
  
  has_and_belongs_to_many  :manufacturers
  has_many    :products
  
  attr_accessible :name, :image
  
  has_attached_file :image,
                  :default_url => "http://depstar.com/assets/:class/missing_:style.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                  #:url  => "http://depstar.com/assets/products/:id/:style/:basename.:extension",
                  :url  => "http://localhost:3000/assets/categories/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/categories/:id/:style/:basename.:extension"  
  
  validates       :name, :presence => true
end
