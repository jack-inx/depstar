class ShippingDetailsController < ApplicationController
  before_filter :authorize, :except => [:new, :create, :confirm, :show, :orders, :order_details]
  before_filter :xml_authorize, :include => [:orders, :order_details]
  
  # GET /shipping_details
  # GET /shipping_details.xml
  def index  
    @shipping_details = ShippingDetail.paginate(:page => params[:page], :order => "created_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shipping_details }
    end
  end

  # GET /shipping_details/1
  # GET /shipping_details/1.xml
  def show    
    @shipping_detail = ShippingDetail.find(params[:id])
    @user = current_user
    
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
  
  def orders
    @conditions = 'UUID IS NOT NULL'
    @limit = 25
    
    @shipping_details_total = @shipping_details = ShippingDetail.find(
      :all,
      :select => 'shipping_details.*, COUNT(*) AS orders_count', 
      :order => "created_at desc",
      :conditions => @conditions,
      :group => 'uuid'
    ).count

    unless params[:start].nil?
      @conditions = @conditions + (' and created_at > ' + params[:start])
    end

    unless params[:end].nil?
      @conditions = @conditions + (' and created_at < ' + params[:end])
    end
    
    unless params[:limit].nil?
      @limit = params[:limit]
    end
    
    @shipping_details = ShippingDetail.find(
      :all,
      :select => 'shipping_details.*, COUNT(*) AS orders_count', 
      :order => "created_at desc",
      :conditions => @conditions,
      :group => 'uuid',
      :limit => @limit
    )
          
    respond_to do |format|
      #format.html # orders.html.erb
      format.xml # orders.xml.builder
    end
  end
  
  def order_details
    @uuid = params[:id]
    @conditions = 'UUID LIKE ' + @uuid
    
    @shipping_details = ShippingDetail.find_all_by_uuid(
      @uuid
    )
    
    respond_to do |format|
      format.xml # order_details.xml.builder
    end
  end
  
  def confirm
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @product = @shipping_detail.product
    @question_response = @shipping_detail.question_response    
    
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
    @options = ''
    
    #debugger
    unless params[:shipping_detail].nil?
      @product = Product.find(params[:shipping_detail][:product_id])
      @question_response = QuestionResponse.find(params[:shipping_detail][:question_response_id])    
    else
      
      @params_to_pass_to_shipping_details = {}

      @product = Product.find(params['product_id'])
      @x = 0

      # Add all options
      params.each do |param|
       key = param[0]
       value = param[1]

       if key.start_with?('option')        
         if value.end_with?('1') == true
           @current_question_option_id = @product.question_options[@x].id
           @options = @options + @current_question_option_id.to_s
         end
         @x = @x + 1
       end

       if key.start_with?('option') or key.start_with?('question')
         @params_to_pass_to_shipping_details[key] = value
       end
      end

      @question_response = QuestionResponse.new(:product_id => params['product_id'], 
       :question_1 => (params[:question_1] == 'answer_1' ? 'True' : 'False'), 
       :question_2 => (params[:question_2] == 'answer_5' ? 'True' : 'False'),
       :question_3 => (case params[:question_3] 
                         when 'answer_5' 
                           '1' 
                         when 'answer_6' 
                           '2'
                         when 'answer_7' 
                           '3'
                         when 'answer_8' 
                           '4'
                         else
                           '0'
                       end),
       :question_4 => @options)
      
      if @question_response.valid?
        @question_response.save
      end
    end
    
    @uuid = nil

    # Required by uSell intergration -- Set a 30 day cookie
    if !params[:uuid].nil? # Always transfer to new UUID if uSell provides one
      cookies[:uuid] = { :value => params[:uuid], :expires => 30.day.from_now }
      @uuid = params[:uuid]
    elsif !cookies[:uuid].nil? # If a new UUID is not provided, use the ID from the cookie
      @uuid = cookies[:uuid]
    end
    
    @shipping_detail.uuid = @uuid unless @uuid.nil?
    @shipping_detail.referer = params[:ref] unless params[:ref].nil?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shipping_detail }
    end
  end

  # GET /shipping_details/1/edit
  def edit
    @shipping_detail = ShippingDetail.find(params[:id])
    @product = @shipping_detail.product
    @question_response = @shipping_detail.question_response
    @user = current_user
    
  end

  # POST /shipping_details
  # POST /shipping_details.xml
  def create
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    @product = Product.find(params[:shipping_detail][:product_id])
    @question_response = QuestionResponse.find(params[:shipping_detail][:question_response_id])
    @tos = params[:tos]
    
    # Take a snapshot of the initial offer
    @shipping_detail.offer = @question_response.quote unless @question_response.nil?
    @shipping_detail.final_offer = @question_response.quote unless @question_response.nil?
    
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
