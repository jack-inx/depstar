class Order < ActiveRecord::Base
  attr_accessible :user_id, :first_name, :last_name, :address, :state, :city, :phone_number, :email,
                  :product_ids, :zip, :order_id, :notes
  
  has_and_belongs_to_many :products
  
  belongs_to :user
  
  Condition = [["Flawless",1],["Used",2],["Broken",3]]
  AffiliateConditionCategory = [["Broken",1],["Defective",2]]
  
  
  before_save :create_order_id
  
  def create_order_id
    #@order = Order.find(self.id)
    self.order_id = "#{self.id}_#{self.user.username}_#{self.products.count}_#{self.first_name}"
    #logger.info "#####################################################################################"
  end

end
