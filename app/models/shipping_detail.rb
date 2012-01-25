class ShippingDetail < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :product
  belongs_to :question_response
	
  validates_presence_of :first_name, :last_name, :address1, :city, :state, :zip, :email, :payment_method_id, :product_id

  validates_format_of :phone,
      :message => "must be a valid telephone number.",
      :with => /^[\(\)0-9\- \+\.]{10,20}$/

  def full_name
    first_name + ' ' + last_name
  end

  def status
    case self.status_code
      when 0
        'AwaitingReceipt'
      when 1
        'Recieved'
      when 2
        'Paid'
      when 3
        'Returned'
      when 4
        'Recycled'
      when 5
        'Cancelled'
      when 6
        'Requote'
      else
        ''
    end
    
  end
  
  def final_offer_or_default
    if !self.final_offer.nil?
      self.final_offer
    elsif !self.question_response.nil? && !self.question_response.quote.nil?
      self.question_response.quote
    else
      0
    end
  end

end
