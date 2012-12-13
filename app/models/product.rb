class Product < ActiveRecord::Base
  
  attr_accessible           :name, :description, :price, :used_price, :broken_price, :is_popular, :photo, :carrier_id,
                            :category_id, :manufacturer_id , :series_list_id
  belongs_to :category
  belongs_to :manufacturer
  belongs_to :carrier
  belongs_to :series_list
  
  has_and_belongs_to_many :orders
  
  has_many :devices

  validates_presence_of :price, :category_id, :manufacturer_id , :series_list_id
  validates_numericality_of :price
  validates_numericality_of :used_price
  validates_numericality_of :broken_price

  has_attached_file :photo,
                  :default_url => "http://depstar.com/assets/:class/missing_:style.gif", 
                  :styles => { :thumb => "100x100#", :small => "125x125>", :medium => "228x166>" },
                  #:url  => "http://depstar.com/assets/products/:id/:style/:basename.:extension",
                  :url  => "http://localhost:3000/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  has_many :question_options
  accepts_nested_attributes_for :question_options, :allow_destroy => true

  #scope :final_product,where('category_id =?',params[:cat_id])
  #scope :final_product do lambda { |*on| where("category_id = ?", on.first && "manufacturer_id = ?",3 ) } end


  self.per_page = 12
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def price_broken
    
    if !self.question_1_option_1_price.nil? 
      @price = self.question_1_option_1_price # Broken price is enabled
    else
      @price = (self.price.to_f * self.question_3_option_1_multiplier.to_f)
    end
    
    @price.round
  end
  
  def price_poor
    (self.price.to_f * self.question_3_option_1_multiplier.to_f).round
  end

  def price_average
    (self.price.to_f * self.question_3_option_2_multiplier.to_f).round
  end
  
  def price_good
    (self.price.to_f * self.question_3_option_3_multiplier.to_f).round
  end
  
  def price_excellent
    (self.price.to_f * self.question_3_option_4_multiplier.to_f).round
  end
  
end