class Suggestion < ActiveRecord::Base
   attr_accessible :user_id, :product_id, :broken_price, :used_price
end
