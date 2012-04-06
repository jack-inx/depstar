class Device < ActiveRecord::Base
  #has_and_belongs_to_many :shipping_details
  belongs_to :shipping_detail
  
  belongs_to :product
  belongs_to :question_response
  
end
