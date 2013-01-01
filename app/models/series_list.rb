class SeriesList < ActiveRecord::Base
  attr_accessible :name, :manufacturer_id, :category_id, :image, :carrier_ids
  has_and_belongs_to_many :carriers, :join_table => :carriers_series_lists  
  belongs_to :manufacturer
  belongs_to :category
  has_attached_file :image,
                  :default_url => "http://depstar.com/assets/:class/missing_:style.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                  :url  => "http://depstar.com/assets/series_lists/:id/:style/:basename.:extension",
                  #:url  => "http://localhost:3000/assets/categories/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/series_lists/:id/:style/:basename.:extension"  
 
  has_many :products, :dependent => :destroy
  
end
