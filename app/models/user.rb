class User < ActiveRecord::Base
  #attr_accessible :username, :email, :password
  attr_accessor :password_confirmation
    
  acts_as_authentic
  
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
