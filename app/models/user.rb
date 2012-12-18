class User < ActiveRecord::Base
  attr_accessible :username, :email, :crypted_password, :persistence_token,:password_salt, :status, :product_ids
  attr_accessor :password_confirmation
   
  has_one :profile, :dependent => :destroy

  has_many :orders 
  has_and_belongs_to_many :products  

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  #validations for username, password, password confirmation and email
  validates :username, :presence =>true,
                       :uniqueness => true,
                       :length => { :within =>6..10 }            
  
  validates :crypted_password, :presence => true, :length => { :within =>6..40 } 
  

  validates :email, :presence => true,
            :uniqueness => true,
            :format => { :with => email_regex }

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
