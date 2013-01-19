class ShippingDetail < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :question_response

  belongs_to :product
  #has_and_belongs_to_many :devices
  has_many :devices
  
  ShippingStatus = [["AwaitingReceipt",0],["Recieved",1],["Paid",2],["Returned",3],["Recycled",4],["Cancelled",5],["Requote",6]]
  
  accepts_nested_attributes_for :devices, :allow_destroy => true
  attr_accessible :first_name, :last_name, :address1, :address2, :city, :state, :zip, :email, :phone
  attr_accessible :check_payment_name, :check_payment_address1, :check_payment_address2, :check_payment_city, :check_payment_state, :check_payment_zip, :paypal_email
  attr_accessible :product_id, :payment_method_id, :paypal_email, :email, :offer, :tos, :status_code
  attr_accessible :uuid, :referer, :status_code, :serial, :final_offer, :notes, :devices_attributes
  
  attr_accessor :should_validate
  attr_accessor :step
  attr_accessor :tos

  attr_accessor :type
    
  validates_presence_of :email, if: :on_email_step?
  validates_presence_of :first_name, :last_name, :address1, :city, :state, :zip, :email, :payment_method_id, if: :on_shipping_step?
  
  validates_presence_of :check_payment_name, :check_payment_address1, :check_payment_city, :check_payment_state, :check_payment_zip, if: :on_get_paid_step_check?
  validates_presence_of :paypal_email, if: :on_get_paid_step_paypal?

  validates_acceptance_of :tos, if: :on_confirm_step?

  #validates_format_of :phone,
      #:message => "must be a valid telephone number.",
      #:with => /^[\(\)0-9\- \+\.]{10,20}$/,
      #:if => :on_shipping_step?
      #:if => :require_phone_validation?
    
  def require_phone_validation?
    # Only for uSell orders phone numbers are optional
    self.referer != 'usell' && self.on_shipping_step?
  end

  def on_confirm_step?
    self.step == :confirm
  end

  def on_get_paid_step_check?
    self.step == :get_paid && payment_method.short_code == 'check'
  end

  def on_get_paid_step_paypal?
    self.step == :get_paid && payment_method.short_code == 'paypal'
  end

  def on_shipping_step?
    self.step == :shipping
  end

  def on_email_step?
    self.step == :email
  end

  def full_name
    first_name.to_s + ' ' + last_name.to_s
  end
  
  def full_address
    address1.to_s + '' + address2.to_s
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
