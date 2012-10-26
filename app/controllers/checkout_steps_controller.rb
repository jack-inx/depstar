class CheckoutStepsController < ApplicationController
  include Wicked::Wizard
  steps :email, :get_paid, :shipping, :confirm#, :done, :thank_you
  
  def show
    if session[:shipping_detail].nil?
      session[:shipping_detail] = ShippingDetail.new()
    end
    
    #logger.debug 'current_shipping_detail  --  ' + current_shipping_detail.inspect
    #logger.debug 'shipping_detail  --  ' + shipping_detail.inspect
    #logger.debug '@shipping_detail -- ' + @shipping_detail.inspect
    #logger.debug 'params ---- ' + params.inspect
    #session[:shipping_detail] = ShippingDetail.new(params[:shipping_detail]) if session[:shipping_detail].nil?
    
    #logger.debug 'session[:shipping_detail] ---- ' + session[:shipping_detail].inspect
    
    #@shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @shipping_detail = session[:shipping_detail]
    @shipping_detail.should_validate = true
    
    # Take product_id from product#show
    if ! params[:product_id].nil?
      @shipping_detail.product = Product.find(params[:product_id])
      #session[:shipping_detail].product = Product.find(params[:product_id])
    elsif ! params[:shipping_detail].nil?
      #logger.debug 'params[:shipping_detail] -------- ' + params[:shipping_detail].inspect
      @shipping_detail.product = Product.find(params[:shipping_detail][:product_id]) unless params[:shipping_detail][:product_id].nil?
      #session[:shipping_detail].product = Product.find(params[:shipping_detail][:product_id]) unless params[:shipping_detail][:product_id].nil?
    end
    
    # Take payment_method from product#show
    unless params[:payment_method].nil?
      @shipping_detail.payment_method_id = PaymentMethod.find_by_short_code(params[:payment_method]).id
      #session[:shipping_detail].payment_method_id = PaymentMethod.find_by_short_code(params[:payment_method]).id
    end
    
    #@shipping_detail = session[:shipping_detail]

    #logger.debug '@shipping_detail ---- ' + @shipping_detail.inspect

    # Take payment_method from product#show
    unless params[:condition].nil?
      if params[:condition] == 'best'
        @shipping_detail.offer = @shipping_detail.product.price_excellent
      elsif params[:condition] == 'good'
        @shipping_detail.offer = @shipping_detail.product.price_average
      elsif params[:condition] == 'broken'
        @shipping_detail.offer = @shipping_detail.product.price_broken
      end
    end
    
    session[:shipping_detail] = @shipping_detail
    
    render_wizard
  end

  def create
    @shipping_detail = User.new(params[:shipping_detail])
    # if @shipping_detail.save
    #       session[:shipping_detail_id] = @shipping_detail.id
    #       redirect_to shipping_details_path, notice: "Thank you for signing up."
    #     else
    #       render :new
    #     end
  end
  
  def update
    #logger.debug "Step -- " + step.inspect
    # logger.debug "Checkout Steps - Update -- " + params.inspect
    # logger.debug "params -- " + params.inspect
    
    #session[:shipping_detail].update_attributes(params[:shipping_detail])
    #@shipping_detail = ShippingDetail.new(session[:shipping_detail])
    #@shipping_detail = session[:shipping_detail]
    
    #@shipping_detail = ShippingDetail.new(params[:shipping_detail])
    #logger.debug "@shipping_detail --- " + @shipping_detail.inspect
    
    @shipping_detail = session[:shipping_detail]
    @shipping_detail.step = step # Sets current step
    
    #@shipping_detail.should_validate = false
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

    @shipping_detail = session[:shipping_detail]
    #logger.debug "@shipping_detail --- " + @shipping_detail.inspect
    logger.debug "@shipping_detail.tos --- " + @shipping_detail.tos.inspect
    
    #session[:shipping_detail] = ShippingDetail.new(params[:shipping_detail])
    #@shipping_detail = session[:shipping_detail]
      
    # @shipping_detail.should_validate = false
    # case step
    # when :shipping
    #   @shipping_detail.should_validate = true
    # end
    
    #@shipping_detail.update_attributes(params[:shipping_detail])
    
    #redirect_to(wizard_path(:email), :notice => 'Category was successfully updated.')
    
    render_wizard @shipping_detail

    # unless @shipping_detail.valid?
    #   render previous_wizard_path
    # else
    #   render_wizard @shipping_detail
    # end
    
    # if step == :done || ! @shipping_detail.valid?
    #   render_wizard @shipping_detail
    # else
    #   render_wizard
    # end
  end
  
  private
  
  def finish_wizard_path
    '/checkout_steps/done'
  end
  
  # def redirect_to_finish_wizard
  #   #reset_session
  #   #redirect_to 
  #   #'checkout_steps/done'
  #   #redirect_to root_url, notice: "Thanks for signing up."
  # end

end
