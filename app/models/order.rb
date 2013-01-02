class Order < ActiveRecord::Base
    
  attr_accessible :user_id, :first_name, :last_name, :address, :state, :city, :phone_number, :email,
                  :product_ids, :zip, :order_id, :notes, :serial_no
  
  has_and_belongs_to_many :products
  
  belongs_to :user
  
  Condition = [["Flawless",1],["Used",2],["Broken",3]]
  AffiliateConditionCategory = [["Broken",1],["Used",2]]
  
  validates :first_name, :presence => true, :length => { :within => 3..30 }
  validates :last_name, :presence => true, :length => { :within => 3..30 }
  
  before_create :create_order_id
  
  def create_order_id
    #@order = Order.find(self.id)
    self.order_id = SecureRandom.hex(3)
    #logger.info "############## #{self.order_id}######################################################################"
  end

end
