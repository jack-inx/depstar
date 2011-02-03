class CorporateController < ApplicationController
   
  def index
    unless params[:corporate_message]            
      @corporate_message = CorporateMessage.new()
    else  
      @corporate_message = CorporateMessage.new(params[:corporate_message])  
    
      if @corporate_message.valid?
        flash[:notice] =  "We have recieved your request. A Depstar representative contact you shortly."
      
        UserMailer.corporate_contact_email(@corporate_message).deliver
        
      end
    
    end
    
  end
  
end
