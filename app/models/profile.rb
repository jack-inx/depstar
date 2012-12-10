class Profile < ActiveRecord::Base
   attr_accessible :user_id, :about_me, :website_url  
   
   belongs_to :user 
   
  has_attached_file :logo,
                  :default_url => "http://depstar.com/assets/products/missing_small.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                  #:url  => "http://depstar.com/assets/products/:id/:style/:basename.:extension",
                  :url  => "http://localhost:3000/assets/categories/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/categories/:id/:style/:basename.:extension"  
  
  
end
