class QuestionResponse < ActiveRecord::Base
  belongs_to :product
  has_many :shipping_details
  has_many :devices

  validates_presence_of :product_id
  validates_presence_of :question_1, :if => lambda { product.question_1_is_enabled unless product.nil? }
  validates_presence_of :question_2, :if => lambda { product.question_2_is_enabled unless product.nil? }
  validates_presence_of :question_3, :if => lambda { product.question_3_is_enabled unless product.nil? }
  # question_4 can be left blank
  
  def quote
    @price = 0 
    @price = (@product.price.to_f * multiplier.to_f).round # unless product.nil?

    unless question_1.blank?
      if !@product.question_1_option_1_price.nil? and question_1 == "True"
        @price = @product.question_1_option_1_price
      elsif !@product.question_1_option_2_price.nil? and question_1 == "False"
        @price = @product.question_1_option_2_price
      end
    end
    
    unless question_2.blank?
      if !@product.question_2_option_1_price.nil? and question_2 == "True"
        @price = @product.question_2_option_1_price
      elsif !@product.question_2_option_2_price.nil? and question_2 == "False"
        @price = @product.question_2_option_2_price
      end
    end
  
    @price
  end
  
  private
  
  def multiplier    
    @multiplier = 1
    @product = product
    
    unless question_1.blank? or @product.question_1_option_1_multiplier.nil?
      if question_1 == "True"
        @multiplier *= @product.question_1_option_1_multiplier
      elsif question_1 == "False"
        @multiplier *= @product.question_1_option_2_multiplier
      end
    end
        
    unless question_2.blank? or @product.question_2_option_1_multiplier.nil?
      if question_2 == "True"
        @multiplier *= @product.question_2_option_1_multiplier
      elsif question_2 == "False"
        @multiplier *= @product.question_2_option_2_multiplier
      end      
    end
        
    unless question_3.blank? or @product.question_3_option_1_multiplier.nil?
      if question_3 == "1"
        @multiplier *= @product.question_3_option_1_multiplier
      elsif question_3 == "2"
        @multiplier *= @product.question_3_option_2_multiplier
      elsif question_3 == "3"
        @multiplier *= @product.question_3_option_3_multiplier        
      elsif question_3 == "4"
        @multiplier *= @product.question_3_option_4_multiplier
      end
    end

    @product.question_options.each do |question_option|

      unless question_4.blank?
        unless question_4.include?(question_option.id.to_s())
          @multiplier *= question_option.multiplier
        end
      else
        @multiplier *= question_option.multiplier
      end      
    end 
        
    @multiplier
    
  end
  
end