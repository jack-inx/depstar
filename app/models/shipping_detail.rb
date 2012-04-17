class ShippingDetail < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :product
  belongs_to :question_response
  
  #has_and_belongs_to_many :devices
	has_many :devices
	
  validates_presence_of :first_name, :last_name, :address1, :city, :state, :zip, :email, :payment_method_id #, :product_id

  validates_format_of :phone,
      :message => "must be a valid telephone number.",
      :with => /^[\(\)0-9\- \+\.]{10,20}$/,
      :if => :require_phone_validation?
  
  attr_accessor :type  
  def require_phone_validation?
    # Only for uSell orders phone numbers are optional
    self.referer != 'usell'
  end

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

  def offer_or_default
    if !self.offer.nil?
      self.offer
    elsif !self.question_response.nil? && !self.question_response.quote.nil?
      self.question_response.quote
    else
      0
    end
  end

  def initial_total_offer
    initial_total_offer = 0
    self.devices.each do |device|
      initial_total_offer += device.offer
    end
  
    initial_total_offer
  end
  
  def final_total_offer
    final_total_offer = 0
    self.devices.each do |device|
      final_total_offer += device.final_offer
    end
  
    final_total_offer
  end
end
