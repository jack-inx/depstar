class User < ActiveRecord::Base
  attr_accessible :username, :email, :crypted_password, :persistence_token,:password_salt, :status, :product_ids
  attr_accessor :password_confirmation
   
  has_one :profile, :dependent => :destroy

  has_many :orders 
  has_and_belongs_to_many :products  
  
  # acts_as_authentic do |c|
    # if is_admin?
      # true
    # else
      # false
    # end
  # end
    

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
  
    def self.checkStatus(username, password)
    @user = self.find_by_username_and_crypted_password_and_status(username, password,true)
    if @user.nil?
      false
    else
      true
    end    
  end
  
end
