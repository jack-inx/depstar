class CheckoutStepsController < ApplicationController
  include Wicked::Wizard
  steps :email, :get_paid, :shipping, :confirm, :done, :thank_you
  
  # def index
  #   render_wizard
  # end
  
  def show
    logger.debug "Step -- " + step.inspect
    logger.debug "params -- " + params.inspect
    
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @shipping_detail.should_validate = true
    
    # Take product_id from product#show
    unless params[:product_id].nil?
      @shipping_detail.product = Product.find(params[:product_id])
    else
      logger.debug 'params[:shipping_detail] -------- ' + params[:shipping_detail].inspect
      @shipping_detail.product = Product.find(params[:shipping_detail][:product_id]) unless params[:shipping_detail][:product_id].nil?
    end
    
    # Take payment_method from product#show
    unless params[:payment_method].nil?
      @shipping_detail.payment_method_id = PaymentMethod.find_by_short_code(params[:payment_method]).id
    end

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
    
    logger.debug "@shipping_detail -- " + @shipping_detail.inspect
    
    # unless params[:product_id].nil? do 
    #   @shipping_detail.product.id = params[:product_id] unless params[:product_id].nil?
    # end
    # 
    # @product = Product.find(params[:id])
    # @question_response = QuestionResponse.new  
    
    # if params[:question_response].nil?
    #   @question_response = QuestionResponse.new  
    # else
    #   @question_response = QuestionResponse.new(params[:question_response])
    # end
    # 
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.xml  { render :xml => @product }
    # end
    
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
    logger.debug "Step -- " + step.inspect
    logger.debug "Checkout Steps - Update -- " + params.inspect
    logger.debug "params -- " + params.inspect
    
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @shipping_detail.should_validate = true
    #     
    # @shipping_detail.should_validate = false
    # case step
    # when :shipping
    #   @shipping_detail.should_validate = true
    # end
    
    #@shipping_detail.update_attributes(params[:shipping_detail])
    
    render_wizard
    #render_wizard @shipping_detail
  end
  
  private
  
  def redirect_to_finish_wizard
    redirect_to root_url, notice: "Thanks for signing up."
  end

end
