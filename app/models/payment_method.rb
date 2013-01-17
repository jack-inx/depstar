class PaymentMethod < ActiveRecord::Base
	has_many :shipping_details
end
