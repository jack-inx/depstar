class CheckoutStepsController < ApplicationController
  include Wicked::Wizard
  steps :email, :get_paid, :shipping, :confirm#, :done, :thank_you
  
  def show
    if session[:shipping_detail].nil?
      session[:shipping_detail] = ShippingDetail.new()
    end
    
    @shipping_detail = session[:shipping_detail]
    @shipping_detail.should_validate = true
    
    # Take product_id from product#show
    if ! params[:product_id].nil?
      @shipping_detail.product = Product.find(params[:product_id])
    elsif ! params[:shipping_detail].nil?
      @shipping_detail.product = Product.find(params[:shipping_detail][:product_id]) unless params[:shipping_detail][:product_id].nil?
    end
    
    # Take payment_method from product#show
    unless params[:payment_method].nil?
      @shipping_detail.payment_method_id = PaymentMethod.find_by_short_code(params[:payment_method])
    end
    
    # Take payment_method from product#show
    unless params[:condition].nil?
      if params[:condition] == 'best'
        @shipping_detail.offer = @shipping_detail.product.price
      elsif params[:condition] == 'good'
        @shipping_detail.offer = @shipping_detail.product.used_price
      elsif params[:condition] == 'broken'
        @shipping_detail.offer = @shipping_detail.product.broken_price
      end
    end
    
    session[:shipping_detail] = @shipping_detail
    
    render_wizard
  end

  def create
    @shipping_detail = User.new(params[:shipping_detail])
  end
  
  def update
    #logger.debug "Step -- " + step.inspect
    
    @shipping_detail = session[:shipping_detail]
    @shipping_detail.step = step # Sets current step
    
    session[:shipping_detail].update_attributes(params[:shipping_detail])
    
    # Remove default text from forms    
    session[:shipping_detail][:first_name] = nil if session[:shipping_detail][:first_name] == "First Name"
    session[:shipping_detail][:last_name] = nil if session[:shipping_detail][:last_name] == "Last Name"
    session[:shipping_detail][:address1] = nil if session[:shipping_detail][:address1] == "Address"
    session[:shipping_detail][:city] = nil if session[:shipping_detail][:city] == "City"
    session[:shipping_detail][:state] = nil if session[:shipping_detail][:state] == "State"
    session[:shipping_detail][:zip] = nil if session[:shipping_detail][:zip] == "Zip"
    session[:shipping_detail][:phone] = nil if session[:shipping_detail][:phone] == "Phone Number"
    
    session[:shipping_detail][:check_payment_name] = nil if session[:shipping_detail][:check_payment_name] == "Payable to"
    session[:shipping_detail][:check_payment_address1] = nil if session[:shipping_detail][:check_payment_address1] == "Address"
    session[:shipping_detail][:check_payment_city] = nil if session[:shipping_detail][:check_payment_city] == "City"
    session[:shipping_detail][:check_payment_state] = nil if session[:shipping_detail][:check_payment_state] == "State"
    session[:shipping_detail][:check_payment_zip] = nil if session[:shipping_detail][:check_payment_zip] == "Zip"
    
    session[:shipping_detail][:paypal_email] = nil if session[:shipping_detail][:paypal_email] == "Paypal email address"
    
    render_wizard @shipping_detail
  end
  
  private
  
  def finish_wizard_path
    @product = @shipping_detail.product;
    @device = Device.new(:product => @product)
    @device.status_code = 0
    # if @device.valid?
    #       @device.save
    #     end
    @device.offer         = @shipping_detail.offer
    @device.final_offer   = @shipping_detail.offer    
    @shipping_detail.devices[0] = @device
    @shipping_detail.save
    #@shipping_detail = session[:shipping_detail]
    
    UserMailer.welcome_email(@shipping_detail).deliver
    UserMailer.new_quote_request_email(@shipping_detail).deliver
    '/checkout_steps/done'
  end

end
