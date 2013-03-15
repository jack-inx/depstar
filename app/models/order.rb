class Order < ActiveRecord::Base
    
  attr_accessible :user_id, :first_name, :last_name, :address, :state_id, :city, :phone_number, :email,

                  :product_ids, :zip, :order_id, :notes, :serial_no, :product_title, :status_code

  
  has_and_belongs_to_many :products
  ShippingStatus = [["Awaiting Receipt",0],["Shipped",1],["Received",2]]

  belongs_to :user
  belongs_to :state
  Condition = [["Flawless",1],["Used",2],["Broken",3]]

  AffiliateConditionCategory = [["Broken",1],["Used",2],["Recycled",3]]

  
  validates :first_name, :presence => true, :length => { :within => 3..30 }
  validates :last_name, :presence => true, :length => { :within => 3..30 }
  
  before_create :create_order_id
  
  def create_order_id
    #@order = Order.find(self.id)
    self.order_id = SecureRandom.hex(3)
    #logger.info "############## #{self.order_id}######################################################################"
  end
  
   def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
  
end
