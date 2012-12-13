class OtherDetail < ActiveRecord::Base
   attr_accessible :product_id, :price_type
  belongs_to :social_detail
end
