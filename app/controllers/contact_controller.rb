class ContactController < ApplicationController

  def index
    
    unless params[:contact_message]            
      @contact_message = ContactMessage.new()
    else  
      @contact_message = ContactMessage.new(params[:contact_message])
    
      if @contact_message.valid?
        flash[:notice] =  "We have recieved your request. A Depstar representative will contact you shortly."

        UserMailer.contact_email(@contact_message).deliver    
      end

    end
  end
  
end