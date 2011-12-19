class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :manufacturer
  
  has_many :shipping_details

  validates_presence_of :price, :category_id
  validates_numericality_of :price

  has_attached_file :photo,
                  :default_url => "http://depstar.com/assets/:class/missing_:style.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>" },
                  :url  => "http://depstar.com/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  has_many :question_options
  accepts_nested_attributes_for :question_options, :allow_destroy => true

  self.per_page = 12
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  def price_poor
    (self.price.to_f * self.question_3_option_1_multiplier.to_f).round
  end
  
  def price_good
    (self.price.to_f * self.question_3_option_3_multiplier.to_f).round
  end
  
  def price_excellent
    (self.price.to_f * self.question_3_option_4_multiplier.to_f).round
  end
  
end