class OrderProductPriceType < ActiveRecord::Base
  attr_accessible :product_id, :order_id, :price_type_id
end
