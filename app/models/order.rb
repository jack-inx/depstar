class Order < ActiveRecord::Base
    
  attr_accessible :user_id, :first_name, :last_name, :address, :state, :city, :phone_number, :email,
                  :product_ids, :zip, :order_id, :notes, :serial_no
  
  has_and_belongs_to_many :products
  
  belongs_to :user
  
  Condition = [["Flawless",1],["Used",2],["Broken",3]]
  AffiliateConditionCategory = [["Broken",1],["Used",2]]
  States =  [['Alabama', 0],['Alaska', 1],['Arizona', 2],['Arkansas', 3],['California', 4],['Colorado', 5],
            ['Connecticut', 6],['Delaware', 7],['District of Columbia', 8],['Florida', 9],['Georgia', 10],
            ['Hawaii', 11],['Idaho', 12],['Illinois', 13],['Indiana', 14],['Iowa', 15],['Kansas', 16],
            ['Kentucky', 17],['Louisiana', 18],['Maine',19],['Maryland', 20],['Massachusetts', 21],['Michigan', 22],
            ['Minnesota', 23],['Mississippi', 24],['Missouri', 25],['Montana', 26],['Nebraska', 27],['Nevada', 28],
            ['New Hampshire', 29],['New Jersey', 30],['New Mexico', 31],['New York', 32],['North Carolina', 33],
            ['North Dakota', 34],['Ohio', 35],['Oklahoma', 36],['Oregon', 37],['Pennsylvania', 38],['Puerto Rico', 39],
            ['Rhode Island', 40],['South Carolina', 41],['South Dakota', 42],['Tennessee', 43],['Texas', 44],
            ['Utah', 45],['Vermont', 46],['Virginia', 47],['Washington', 48],['West Virginia', 49],
            ['Wisconsin', 50],['Wyoming', 51]]
  
  validates :first_name, :presence => true, :length => { :within => 3..30 }
  validates :last_name, :presence => true, :length => { :within => 3..30 }
  
  before_create :create_order_id
  
  def create_order_id
    #@order = Order.find(self.id)
    self.order_id = SecureRandom.hex(3)
    #logger.info "############## #{self.order_id}######################################################################"
  end

end
