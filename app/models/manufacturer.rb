class Manufacturer < ActiveRecord::Base
  
  has_many :products
  has_and_belongs_to_many   :categories
  has_and_belongs_to_many   :carriers

  attr_accessible   :name, :photo 

  has_attached_file :photo,
                    :default_url => "http://depstar.com/assets/:class/missing_:style.gif", 
                    :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                    #:url  => "http://depstar.com/assets/products/:id/:style/:basename.:extension",
                    :url  => "http://localhost:3000/assets/manufacturers/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/manufacturers/:id/:style/:basename.:extension"

  
end
