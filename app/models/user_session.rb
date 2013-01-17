class UserSession < ActiveRecord::Base
  
  # def to_key
    # new_record? ? nil : [ self.send(self.class.primary_key) ]
  # end
# 
  # def persisted?
    # false
  # end
  
  def self.check(email, password)
    @user = User.find_by_email_and_crypted_password(email, password)
    if @user.nil?
      false
    else
      @user.id
    end    
  end
  
end
