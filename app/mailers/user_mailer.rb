class UserMailer < ActionMailer::Base
  default :from => "info@depstar.com"
  
  def welcome_email(shipping_detail)
    @shipping_detail = shipping_detail
    
    mail(:to => shipping_detail.email,
         :subject => "Product Offer Accepted")
  end
  
  def new_quote_request_email(shipping_detail)
    @shipping_detail = shipping_detail
    
    mail(:to => 'charles.palleschi@gmail.com, charlie@reverejournal.com',
         :subject => "New Quote Request")
  end
  
  def test_email
    mail(:from => 'charles.palleschi@gmail.com',
      :to => 'info@depstar.com',
      :subject => "This is test email",
      :message => "It should get delivered to recipient inbox")
  end
    
end
