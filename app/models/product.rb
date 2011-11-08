class Product < ActiveRecord::Base
  belongs_to :category
  
  has_many :shipping_details

  validates_presence_of :price, :category_id
  validates_numericality_of :price

  has_attached_file :photo, :default_url => "/assets/:class/missing_:style.gif", 
                  :styles => { :small => "125x125>" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  has_many :question_options
  accepts_nested_attributes_for :question_options, :allow_destroy => true

  self.per_page = 12
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end