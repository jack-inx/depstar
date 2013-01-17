class UserMailer < ActionMailer::Base
  default :from => "info@depstar.com"
  
  def welcome_email(shipping_detail, condition)
    
    @shipping_detail = shipping_detail
    @condition = condition
    
    mail(
      :to => shipping_detail.email,
      :bcc => 'orderconfirmation@depstar.com',  
      :subject => "Product Offer Accepted")
  end
  
  def new_quote_request_email(shipping_detail)
    @shipping_detail = shipping_detail
    
    if Rails.env == 'development'
      mail(:to => 'charles.palleschi@sparkwiresolutions.com', :subject => "New Quote Request")
    else
      mail(:to => 'orders@depstar.com', :subject => "New Quote Request")
    end
  end
  
  def corporate_contact_email(corporate_message)
    @corporate_message = corporate_message
    
    mail(:to => 'info@depstar.com',
      :subject => "Depstar - Corporate Contact")
  end
    
  def contact_email(contact_message)
    @contact_message = contact_message
    
    mail(:to => 'info@depstar.com',
      :subject => "Depstar - Contact")
  end  
  
  def welcome_affiliate_email(username, password, email)    
   
    @email = email
    @password = password
    @username = username
    
     if Rails.env.production?
      @root = "Depstar.com"
    else  
      @root = "localhost:3000"
    end
    
    mail(
      :to => @email,
      :bcc => 'himanshu.saxena@inheritx.com',
      #:bcc => 'orderconfirmation@depstar.com',  
      :subject => "Affiliate Creation")
  end
  
  
  def affiliate_password_email(username, password, email)    
   
    @email = email
    @password = password
    @username = username
    
     if Rails.env.production?
      @root = "Depstar.com"
    else  
      @root = "localhost:3000"
    end
    
    mail(
      :to => @email,
      :bcc => 'himanshu.saxena@inheritx.com',
      #:bcc => 'orderconfirmation@depstar.com',  
      :subject => "Affiliate Update")
  end
  
    
end
