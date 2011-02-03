class ShippingDetail < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :product
  belongs_to :question_response
	
  validates_presence_of :first_name, :last_name, :address1, :city, :state, :zip, :email, :payment_method_id, :product_id

end
