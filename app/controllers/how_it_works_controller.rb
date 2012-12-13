class HowItWorksController < ApplicationController

  def index    
    @categories = Category.all
    @index = 0
    @categories.each do |category|             
      if category.name.eql?("iPhones") or category.name.eql?("iPhone")
        @temp = @categories[0]
        @categories[0] = @categories[@index]
        @categories[@index] = @temp  
      end
      @index += 1    
    end
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @question_response }
    end
  end

end
