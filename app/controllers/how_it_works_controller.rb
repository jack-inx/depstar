class HowItWorksController < ApplicationController

  def index    
    @categories = Category.all
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @question_response }
    end
  end

end
