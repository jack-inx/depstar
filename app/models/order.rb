class Order < ActiveRecord::Base
  attr_accessible :user_id, :first_name, :last_name, :address, :state, :city, :phone_number, :email,
                  :product_ids, :zip
  
  has_and_belongs_to_many :products
  
  belongs_to :user
  
  Condition = [["Flawless",1],["Used",2],["Broken",3]]
  
end
