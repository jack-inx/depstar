class Device < ActiveRecord::Base
  #has_and_belongs_to_many :shipping_details
  belongs_to :shipping_detail
  
  belongs_to :product
  belongs_to :question_response

  def name
    self.product.name unless product.nil?
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
  
end
