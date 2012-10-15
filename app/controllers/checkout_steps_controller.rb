class CheckoutStepsController < ApplicationController
  include Wicked::Wizard
  steps :email, :get_paid, :shipping, :confirm, :done, :thank_you
  
  def show
    # CP TODO - Put checkout show logic here
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    
    render_wizard
  end

  def create
    @shipping_detail = User.new(params[:shipping_detail])
    if @shipping_detail.save
      session[:shipping_detail_id] = @shipping_detail.id
      redirect_to shipping_details_path, notice: "Thank you for signing up."
    else
      render :new
    end
  end
  
  def update
    #@shipping_detail = current_shipping_details
    #@shipping_detail.attributes = params[:shipping_detail]
    @shipping_detail = User.new(params[:shipping_detail])
    render_wizard @shipping_detail
    #next_step
  end
  
  private
  
  def redirect_to_finish_wizard
    redirect_to root_url, notice: "Thanks for signing up."
  end

end
