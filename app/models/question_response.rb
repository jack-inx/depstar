require 'active_model'

class QuestionResponse
  extend ActiveModel::Naming 
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::MassAssignmentSecurity
  
  validates_presence_of :product_id, :question_1, :question_2, :question_3, :question_4

  attr_accessor :product_id, :question_1, :question_2, :question_3, :question_4  

  def initialize(params = nil)

    unless params.nil?
      @product_id = params[:id] unless params[:id].nil?
      @question_1 = params[:question_1] unless params[:question_1].nil?
      @question_2 = params[:question_2] unless params[:question_2].nil?
      @question_3 = params[:question_3] unless params[:question_3].nil?
      @question_4 = params[:question_4] unless params[:question_4].nil?
    end
    
    unless @product_id.nil?
      @product = Product.find(@product_id)
    else
      @product = nil
    end
    
  end

  def persisted?
    false
  end
  
  def quote
    @product.price * multiplier
  end
  
  private
  
  def multiplier    
    @multiplier = 1
    
    unless @question_1.blank?      
      if @question_1 == "True"
        @multiplier *= @product.category.question_1_option_1_multiplier
      elsif @question_1 == "False"
        @multiplier *= @product.category.question_1_option_2_multiplier
      end
    end
        
    unless @question_2.blank?      
      if @question_2 == "True"
        @multiplier *= @product.category.question_2_option_1_multiplier
      elsif @question_2 == "False"
        @multiplier *= @product.category.question_2_option_2_multiplier
      end      
    end
        
    unless @question_3.blank?      
      if @question_3 == "1"
        @multiplier *= @product.category.question_3_option_1_multiplier
      elsif @question_3 == "2"
        @multiplier *= @product.category.question_3_option_2_multiplier
      elsif @question_3 == "3"
        @multiplier *= @product.category.question_3_option_3_multiplier        
      elsif @question_3 == "4"
        @multiplier *= @product.category.question_3_option_4_multiplier
      end
    end

    @product.category.question_options.each do |question_option|

      unless @question_4.blank?                
        unless @question_4.include?(question_option.id.to_s())
          @multiplier *= question_option.multiplier
        end
      else
        @multiplier *= question_option.multiplier
      end      
    end 
        
    @multiplier
    
  end
  
end