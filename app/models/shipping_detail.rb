class ShippingDetail < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :address1, :address2, :city, :state, :zip, :email, :payment_method_id, :product_id
  
end
