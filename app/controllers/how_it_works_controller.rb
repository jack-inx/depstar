class HowItWorksController < ApplicationController

  def index
    #@products = Product.find_all_by_is_popular(true)
    @categories = Category.find_all_by_is_popular(true)
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @question_response }
    end
  end

end
