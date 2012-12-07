class UserSession < ActiveRecord::Base
  
  # def to_key
    # new_record? ? nil : [ self.send(self.class.primary_key) ]
  # end
# 
  # def persisted?
    # false
  # end
  
  def self.check(username, password)
    @user = User.find_by_username_and_crypted_password(username, password)
    if @user.nil?
      false
    else
      @user.id
    end    
  end
  
end
