class Carrier < ActiveRecord::Base
  
  has_and_belongs_to_many  :manufacturers, :join_table => :carriers_manufacturers
  has_many    :products, :dependent => :destroy
  has_and_belongs_to_many :series_lists, :join_table => :carriers_series_lists  
  attr_accessible :name, :image,:series_list_ids
  
  has_attached_file :image,
                  :default_url => "http://depstar.com/assets/categories/missing_small.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                  :url  => "http://depstar.com/assets/categories/:id/:style/:basename.:extension",
                  #:url  => "http://localhost:3000/assets/categories/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/categories/:id/:style/:basename.:extension"  
  
  validates       :name, :presence => true

end
