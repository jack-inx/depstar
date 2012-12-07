class User < ActiveRecord::Base
  attr_accessible :username, :email, :crypted_password, :persistence_token,:password_salt
  attr_accessor :password_confirmation
    
  # acts_as_authentic do |c|
    # if is_admin?
      # true
    # else
      # false
    # end
  # end
  
  after_create :send_email

  def send_email
    UserMailer.welcome_affiliate_email(self.username, self.crypted_password, self.email).deliver
  end
  
  def empty?
    if username == nil || email == nil || crypted_password == nil
      true
    else
      false
    end    
  end
  
  def is_admin?
    self.is_admin == true unless self == nil    
  end
  
end
