class ShippingDetailsController < ApplicationController
  before_filter :authorize, :except => [:new, :create, :confirm, :show]
  
  # GET /shipping_details
  # GET /shipping_details.xml
  def index
    @shipping_details = ShippingDetail.find(:all, :order => "created_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shipping_details }
    end
  end

  # GET /shipping_details/1
  # GET /shipping_details/1.xml
  def show    
    @shipping_detail = ShippingDetail.find(params[:id])
    
    @sellcell_tracking_code = nil
    if current_user.nil? # Only show tracking pixel for users that are not logged in
      # Begin sellcell.com tracking code
      @basket_total = @shipping_detail.question_response.quote.to_s
      @transaction_id = @shipping_detail.id.to_s
      @tracking_string = @shipping_detail.product.to_param
    
      @sellcell_tracking_code = "https://spear.directtrack.com/i_sale/spear/81/:prod:" + @basket_total + ":qty:1/" + @transaction_id + "/" + @tracking_string + "&sale_status=sale_pend"
      # End sellcell.com tracking code
    end
    
    respond_to do |format|
      unless flash[:notice] == "Please check your email for confirmation" || !current_user.nil?
        format.html { redirect_to(login_path) }
      else
          format.html # show.html.erb
      end
      format.xml  { render :xml => @shipping_detail }
    end    
  end
  
  def confirm
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @product = @shipping_detail.product
    @question_response = @shipping_detail.question_response    
    #debugger 
    
    if @shipping_detail.valid?
      UserMailer.welcome_email(@shipping_detail).deliver
      UserMailer.new_quote_request_email(@shipping_detail).deliver
    else  
      render :action => :new
    end
    
  end

  # GET /shipping_details/new
  # GET /shipping_details/new.xml
  def new
    @shipping_detail = ShippingDetail.new    
    @product = Product.find(params[:shipping_detail][:product_id])
    @question_response = QuestionResponse.find(params[:shipping_detail][:question_response_id])

    @shipping_detail.uuid = params[:uuid] unless params[:uuid].nil?
    @shipping_detail.referer = params[:ref] unless params[:ref].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shipping_detail }
    end
  end

  # GET /shipping_details/1/edit
  def edit
    @shipping_detail = ShippingDetail.find(params[:id])
  end

  # POST /shipping_details
  # POST /shipping_details.xml
  def create
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @product = Product.find(params[:shipping_detail][:product_id])
    @question_response = QuestionResponse.find(params[:shipping_detail][:question_response_id])
    @tos = params[:tos]
    
    respond_to do |format|
      if @tos.nil?
        flash[:error] = "You must first agree to the terms of service"
        format.html { render :action => "new", :product_id => @product.id, :question_response_id => @question_response.id, :notice => "You must first agree to the terms of service" }
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      elsif @shipping_detail.save
        UserMailer.welcome_email(@shipping_detail).deliver
        UserMailer.new_quote_request_email(@shipping_detail).deliver
        
        format.html { redirect_to(@shipping_detail, :notice => 'Please check your email for confirmation') }
        format.xml  { render :xml => @shipping_detail, :status => :created, :location => @shipping_detail }
      else
        format.html { render :action => "new", :product_id => @product.id, :question_response_id => @question_response.id }
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shipping_details/1
  # PUT /shipping_details/1.xml
  def update
    @shipping_detail = ShippingDetail.find(params[:id])

    respond_to do |format|
      if @shipping_detail.update_attributes(params[:shipping_detail])
        format.html { redirect_to(@shipping_detail, :notice => 'Shipping detail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_details/1
  # DELETE /shipping_details/1.xml
  def destroy
    @shipping_detail = ShippingDetail.find(params[:id])
    @shipping_detail.destroy

    respond_to do |format|
      format.html { redirect_to(shipping_details_url) }
      format.xml  { head :ok }
    end
  end
end
