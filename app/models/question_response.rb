class QuestionResponse < ActiveRecord::Base
  belongs_to :product
  has_many :shipping_details

  validates_presence_of :product_id
  validates_presence_of :question_1, :if => lambda { product.category.question_1_is_enabled }
  validates_presence_of :question_2, :if => lambda { product.category.question_2_is_enabled }
  validates_presence_of :question_3, :if => lambda { product.category.question_3_is_enabled }
  # question_4 can be left blank
  
  def quote
    product.price * multiplier
  end
  
  private
  
  def multiplier    
    @multiplier = 1
    #debugger
    
    unless question_1.blank?      
      if question_1 == "True"
        @multiplier *= @product.category.question_1_option_1_multiplier
      elsif question_1 == "False"
        @multiplier *= @product.category.question_1_option_2_multiplier
      end
    end
        
    unless question_2.blank?      
      if question_2 == "True"
        @multiplier *= @product.category.question_2_option_1_multiplier
      elsif question_2 == "False"
        @multiplier *= @product.category.question_2_option_2_multiplier
      end      
    end
        
    unless question_3.blank?      
      if question_3 == "1"
        @multiplier *= @product.category.question_3_option_1_multiplier
      elsif question_3 == "2"
        @multiplier *= @product.category.question_3_option_2_multiplier
      elsif question_3 == "3"
        @multiplier *= @product.category.question_3_option_3_multiplier        
      elsif question_3 == "4"
        @multiplier *= @product.category.question_3_option_4_multiplier
      end
    end

    @product.category.question_options.each do |question_option|

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