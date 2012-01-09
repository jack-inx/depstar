class UserMailer < ActionMailer::Base
  default :from => "info@depstar.com"
  
  def welcome_email(shipping_detail)
    
    @shipping_detail = shipping_detail
    
    mail(
      :to => shipping_detail.email,
      :bcc => 'orderconfirmation@depstar.com'  
      :subject => "Product Offer Accepted")
  end
  
  def new_quote_request_email(shipping_detail)
    @shipping_detail = shipping_detail
    
    if RAILS_ENV == 'development'
      mail(:to => 'charles.palleschi@sparkwiresolutions.com', :subject => "New Quote Request")
    else
      #mail(:to => 'bijancronin@gmail.com, jacobresnek@gmail.com', :subject => "New Quote Request")
      mail(:to => 'orders@depstar.com', :subject => "New Quote Request")
    end
  end
  
  def corporate_contact_email(corporate_message)
    @corporate_message = corporate_message
    
    mail(:to => 'info@depstar.com',
      :subject => "Depstar - Corporate Contact")
  end
    
end
