class Product < ActiveRecord::Base
  belongs_to :category

  has_attached_file :photo, :default_url => "/assets/:class/missing_:style.jpg", 
                  :styles => { :small => "125x125>" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
    
end