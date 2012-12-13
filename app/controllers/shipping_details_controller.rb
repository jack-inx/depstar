class ShippingDetailsController < ApplicationController
  include AwesomeUSPS
  
  before_filter :authorize, :except => [:new, :create, :confirm, :show, :orders, :order_details, :submit_external_order, :checkout, :customers, :showdata, :updatedata]
  before_filter :xml_authorize, :include => [:orders, :order_details, :submit_external_order, :checkout, :customers],:except=>[:show_data, :updatedata]
    
  @@var = ""
  
  # GET /shipping_details
  # GET /shipping_details.xml
  def index
    #@shipping_details = ShippingDetail.all(:order => "created_at desc")
    @shipping_details = ShippingDetail.paginate(:page => params[:page], :per_page => 2000, :order => "created_at desc")

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
    #debugger
    respond_to do |format|
      format.xml # order_details.xml.builder
    end
  end
  
  def submit_external_order
    # Testing from the command line
    # echo '<customer><uuid>191231-98adfa91-asd82-9afsd</uuid><first_name>Charles</first_name><last_name>Palleschi</last_name><email>charles@depstar.com</email><phone>6171234567</phone><paypal_email>charles_paypal@depstar.com</paypal_email><shipping_option_selected>1</shipping_option_selected><payment_option_selected>1</payment_option_selected><shipping_address><address1>447 Broadway</address1><address2>2nd Floor</address2><city>Boston</city><state>MA</state><zip>02129</zip></shipping_address><billing_address /><offers><offer><initial_product_id>1</initial_product_id><initial_offer>108.50</initial_offer><category_id>2</category_id><questions><question><question_id>question_1</question_id><answer_id>answer_1</answer_id></question><question><question_id>question_2</question_id><answer_id>answer_2</answer_id></question></questions></offer><offer><initial_product_id>4</initial_product_id><initial_offer>45.12</initial_offer><category_id>3</category_id><questions><question><question_id>question_1</question_id><answer_id>answer_3</answer_id></question><question><question_id>question_2</question_id><answer_id>answer_5</answer_id></question></questions></offer></offers></customer>' | curl -X POST -H 'Content-type: text/xml' -d @- http://127.0.0.1:3000/orders/submit.xml --basic -u "depstar1:wonderland"    
    @status = 'failure'
    
    unless params[:customer].nil?
      @uuid = params[:customer][:uuid] unless params[:customer].nil?
      
      if params[:customer][:payment_option_selected] == "4"
        @payment_method_id = PaymentMethod.find_by_short_code('check').id # Check
      else
        @payment_method_id = PaymentMethod.find_by_short_code('paypal').id # Paypal
      end
      
      @shipping_detail = ShippingDetail.new()
      @shipping_detail.first_name = params[:customer][:first_name]
      @shipping_detail.last_name = params[:customer][:last_name]
      @shipping_detail.address1 = params[:customer][:shipping_address][:address1]
      @shipping_detail.address2 = params[:customer][:shipping_address][:address2]      
      @shipping_detail.city = params[:customer][:shipping_address][:city]
      @shipping_detail.state = params[:customer][:shipping_address][:state]
      @shipping_detail.zip = params[:customer][:shipping_address][:zip]
      @shipping_detail.email = params[:customer][:email]
      @shipping_detail.payment_method_id = @payment_method_id
      @shipping_detail.paypal_email = params[:customer][:paypal_email] unless params[:customer][:paypal_email].nil?
      #@shipping_detail.product_id # No longer used 
      @shipping_detail.requires_box = 1
      #@shipping_detail.question_response_id # No longer used   
      @shipping_detail.phone = params[:customer][:phone] unless params[:customer][:phone].nil?
      @shipping_detail.uuid = @uuid
      @shipping_detail.referer = 'usell'
      #@shipping_detail.offer =  # No longer used 
      #@shipping_detail.final_offer =  # No longer used 
      
      params[:customer][:offers][:offer].each_with_index do |offer, index|
        #puts 'DEBUG 2 - ' + params[:customer][:offers][:offer].inspect
        #puts 'DEBUG 3 - ' + params[:customer][:offers].size.inspect
        
        # It should work without this but in the case there is just 1 <offer> 
        # rails does a .each on it's elements (not the list of offers)
        # this will prevent that from happening
        if params[:customer][:offers][:offer].include?(:initial_offer)
          #next if offer = params[:customer][:offers][:offer]
                    
          offer = params[:customer][:offers][:offer]          
        
          next if index != 0
          #puts 'DEBUG 5- ' + index.inspect
        end
        #puts 'DEBUG - ' + params[:customer][:offers].inspect
        #puts 'DEBUG 2- ' + params[:customer][:offers].size.inspect # = 1 when there is 1 offer
        #puts 'DEBUG 3- ' + params[:customer][:offers][:offer].size.inspect
        #puts 'DEBUG 4- ' + params[:customer][:offers][:offer].include?(:initial_offer).inspect
        
        
        @question_response = QuestionResponse.new()
        
        offer[:questions][:question].each do |question|

          if question[:question_id] == 'question_1'
          begin
            @question_response.question_1 = (question[:answer_id] == 'answer_1' ? 'True' : 'False')
          end
          elsif question[:question_id] == 'question_2'
            @question_response.question_2 = (question[:answer_id] == 'answer_3' ? 'True' : 'False')
          elsif question[:question_id] == 'question_3'
            @question_response.question_3 = (case question[:answer_id]
                                       when 'answer_5' 
                                         1 
                                       when 'answer_6' 
                                         2
                                       when 'answer_7' 
                                         3
                                       when 'answer_8' 
                                         4
                                       else
                                         0
                                     end)
          end
            
          # TODO - Do we need question 4 ?
          #@question_response.question_4 = 
        end
        
        @question_response.product_id = offer[:initial_product_id]
        if @question_response.save
          @device = Device.new()
          @device.product_id = offer[:initial_product_id]
          @device.question_response_id = @question_response.id
          @device.final_offer = offer[:initial_offer]
          @device.offer = offer[:initial_offer]
          @device.status_code = 0
          
          @shipping_detail.devices.push(@device)
        end
        
      end
      
      if @shipping_detail.save
        @status = 'success'
        @order_id = @shipping_detail.id
        @customer_id = @shipping_detail.id     
        
        UserMailer.welcome_email(@shipping_detail).deliver
        UserMailer.new_quote_request_email(@shipping_detail).deliver 
      else
        @error = @shipping_detail.errors.inspect
      end
      
    else 
      @error = 'Malformed XML request - <customer/> not found'
    end
    
    respond_to do |format|
      format.xml # submit_external_order.xml.builder
    end
  end
  
  def checkout
    
    respond_to do |format|
      format.xml  # checkout.xml.builder
    end
  end
  
  def customers
    @error = nil
    
    # Don't throw exception of record not found
    # Use referer = 'usell' here - This will only work with orders with uSell
    # We don't want them to get snoopy on other customers
    if ShippingDetail.find(:first, :conditions => ['referer = ? AND id = ?', 'usell', params[:id]])
      @shipping_detail = ShippingDetail.find(params[:id])
    else
      @error = 'Customer not found'
    end
    
    respond_to do |format|
      format.xml  # customers.xml.builder
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
    
    @device = Device.new(:product_id => params['shipping_detail']['product_id'],
      :question_response_id => @question_response.id
      )
    @device.status_code = 0
      
    if @device.valid?
      @device.save
    end
    
    # Assume just 1 device per shipping details
    @shipping_detail.devices[0] = @device
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
    @product = @shipping_detail.productclass ShippingDetailsController < ApplicationController
  include AwesomeUSPS
  
  before_filter :authorize, :except => [:new, :create, :confirm, :show, :orders, :order_details, :submit_external_order, :checkout, :customers, :showdata, :updatedata]
  before_filter :xml_authorize, :include => [:orders, :order_details, :submit_external_order, :checkout, :customers],:except=>[:show_data, :updatedata]
    
  @@var = ""
  
  # GET /shipping_details
  # GET /shipping_details.xml
  def index
    @user = ShippingDetail.find_by_user_id(session[:current_user])
    #@shipping_details = ShippingDetail.all(:order => "created_at desc")
    @shipping_details = ShippingDetail.where(:user_id => session[:current_user]).paginate(:page => params[:page], :per_page => 2000, :order => "created_at desc")

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
    #debugger
    respond_to do |format|
      format.xml # order_details.xml.builder
    end
  end
  
  def submit_external_order
    # Testing from the command line
    # echo '<customer><uuid>191231-98adfa91-asd82-9afsd</uuid><first_name>Charles</first_name><last_name>Palleschi</last_name><email>charles@depstar.com</email><phone>6171234567</phone><paypal_email>charles_paypal@depstar.com</paypal_email><shipping_option_selected>1</shipping_option_selected><payment_option_selected>1</payment_option_selected><shipping_address><address1>447 Broadway</address1><address2>2nd Floor</address2><city>Boston</city><state>MA</state><zip>02129</zip></shipping_address><billing_address /><offers><offer><initial_product_id>1</initial_product_id><initial_offer>108.50</initial_offer><category_id>2</category_id><questions><question><question_id>question_1</question_id><answer_id>answer_1</answer_id></question><question><question_id>question_2</question_id><answer_id>answer_2</answer_id></question></questions></offer><offer><initial_product_id>4</initial_product_id><initial_offer>45.12</initial_offer><category_id>3</category_id><questions><question><question_id>question_1</question_id><answer_id>answer_3</answer_id></question><question><question_id>question_2</question_id><answer_id>answer_5</answer_id></question></questions></offer></offers></customer>' | curl -X POST -H 'Content-type: text/xml' -d @- http://127.0.0.1:3000/orders/submit.xml --basic -u "depstar1:wonderland"    
    @status = 'failure'
    
    unless params[:customer].nil?
      @uuid = params[:customer][:uuid] unless params[:customer].nil?
      
      if params[:customer][:payment_option_selected] == "4"
        @payment_method_id = PaymentMethod.find_by_short_code('check').id # Check
      else
        @payment_method_id = PaymentMethod.find_by_short_code('paypal').id # Paypal
      end
      
      @shipping_detail = ShippingDetail.new()
      @shipping_detail.first_name = params[:customer][:first_name]
      @shipping_detail.last_name = params[:customer][:last_name]
      @shipping_detail.address1 = params[:customer][:shipping_address][:address1]
      @shipping_detail.address2 = params[:customer][:shipping_address][:address2]      
      @shipping_detail.city = params[:customer][:shipping_address][:city]
      @shipping_detail.state = params[:customer][:shipping_address][:state]
      @shipping_detail.zip = params[:customer][:shipping_address][:zip]
      @shipping_detail.email = params[:customer][:email]
      @shipping_detail.payment_method_id = @payment_method_id
      @shipping_detail.paypal_email = params[:customer][:paypal_email] unless params[:customer][:paypal_email].nil?
      #@shipping_detail.product_id # No longer used 
      @shipping_detail.requires_box = 1
      #@shipping_detail.question_response_id # No longer used   
      @shipping_detail.phone = params[:customer][:phone] unless params[:customer][:phone].nil?
      @shipping_detail.uuid = @uuid
      @shipping_detail.referer = 'usell'
      #@shipping_detail.offer =  # No longer used 
      #@shipping_detail.final_offer =  # No longer used 
      
      params[:customer][:offers][:offer].each_with_index do |offer, index|
        #puts 'DEBUG 2 - ' + params[:customer][:offers][:offer].inspect
        #puts 'DEBUG 3 - ' + params[:customer][:offers].size.inspect
        
        # It should work without this but in the case there is just 1 <offer> 
        # rails does a .each on it's elements (not the list of offers)
        # this will prevent that from happening
        if params[:customer][:offers][:offer].include?(:initial_offer)
          #next if offer = params[:customer][:offers][:offer]
                    
          offer = params[:customer][:offers][:offer]          
        
          next if index != 0
          #puts 'DEBUG 5- ' + index.inspect
        end
        #puts 'DEBUG - ' + params[:customer][:offers].inspect
        #puts 'DEBUG 2- ' + params[:customer][:offers].size.inspect # = 1 when there is 1 offer
        #puts 'DEBUG 3- ' + params[:customer][:offers][:offer].size.inspect
        #puts 'DEBUG 4- ' + params[:customer][:offers][:offer].include?(:initial_offer).inspect
        
        
        @question_response = QuestionResponse.new()
        
        offer[:questions][:question].each do |question|

          if question[:question_id] == 'question_1'
          begin
            @question_response.question_1 = (question[:answer_id] == 'answer_1' ? 'True' : 'False')
          end
          elsif question[:question_id] == 'question_2'
            @question_response.question_2 = (question[:answer_id] == 'answer_3' ? 'True' : 'False')
          elsif question[:question_id] == 'question_3'
            @question_response.question_3 = (case question[:answer_id]
                                       when 'answer_5' 
                                         1 
                                       when 'answer_6' 
                                         2
                                       when 'answer_7' 
                                         3
                                       when 'answer_8' 
                                         4
                                       else
                                         0
                                     end)
          end
            
          # TODO - Do we need question 4 ?
          #@question_response.question_4 = 
        end
        
        @question_response.product_id = offer[:initial_product_id]
        if @question_response.save
          @device = Device.new()
          @device.product_id = offer[:initial_product_id]
          @device.question_response_id = @question_response.id
          @device.final_offer = offer[:initial_offer]
          @device.offer = offer[:initial_offer]
          @device.status_code = 0
          
          @shipping_detail.devices.push(@device)
        end
        
      end
      
      if @shipping_detail.save
        @status = 'success'
        @order_id = @shipping_detail.id
        @customer_id = @shipping_detail.id     
        
        UserMailer.welcome_email(@shipping_detail).deliver
        UserMailer.new_quote_request_email(@shipping_detail).deliver 
      else
        @error = @shipping_detail.errors.inspect
      end
      
    else 
      @error = 'Malformed XML request - <customer/> not found'
    end
    
    respond_to do |format|
      format.xml # submit_external_order.xml.builder
    end
  end
  
  def checkout
    
    respond_to do |format|
      format.xml  # checkout.xml.builder
    end
  end
  
  def customers
    @error = nil
    
    # Don't throw exception of record not found
    # Use referer = 'usell' here - This will only work with orders with uSell
    # We don't want them to get snoopy on other customers
    if ShippingDetail.find(:first, :conditions => ['referer = ? AND id = ?', 'usell', params[:id]])
      @shipping_detail = ShippingDetail.find(params[:id])
    else
      @error = 'Customer not found'
    end
    
    respond_to do |format|
      format.xml  # customers.xml.builder
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
    if params[:login]!= 'true'

    
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
        
        @device = Device.new(:product_id => params['shipping_detail']['product_id'],
          :question_response_id => @question_response.id
          )
        @device.status_code = 0
          
        if @device.valid?
          @device.save
        end
        
        # Assume just 1 device per shipping details
        @shipping_detail.devices[0] = @device
        @shipping_detail.uuid = @uuid unless @uuid.nil?
        @shipping_detail.referer = params[:ref] unless params[:ref].nil?

else
  @brow = 1 
end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shipping_detail }
    end
  end
  
  def new_data
    @shipping_detail = ShippingDetail.new
  end

  # GET /shipping_details/1/edit
  def edit
    @shipping_detail = ShippingDetail.find(params[:id])
    @product = @shipping_detail.products
    @question_response = @shipping_detail.question_response
    @user = current_user
    
    #logger.debug "@question_response ----- " + ShippingDetail.find(params[:id]).inspect
    
    # @purchase = Stamps.purchase_postage(
    #   :amount => 100,
    #   :control_total => 200
    # )
    
    # stamps_local = Stamps.clone # Make local copy
    # #print 'stamps_local.inspect ---- ' + stamps_local.inspect + '----'
    # #print 'stamps_local.inspect ---- ' + stamps_local.inspect + '----'
    # #@available_postage = Stamps.account.inspect
    # unless stamps_local.blank?
    #   unless stamps_local.account.blank?
    #     unless stamps_local.account[:valid?] == false
    #       @available_postage = stamps_local.account[:postage_balance][:available_postage]
    #     end
    #   end
    # end
    
  end

  # POST /shipping_details
  # POST /shipping_details.xml
  def create
    
    if !params[:products].nil?
      
      @@var = params[:products][:product_list].collect!{|i| i.to_i}

      params[:shipping_detail][:product_ids] = params[:products][:product_list].collect!{|i| i.to_i}    

      @shipping_detail = ShippingDetail.new(params[:shipping_detail])     
      
      @array = params[:products][:product_list]     
      @product = Product.find(params[:products][:product_list][0])
      
    if params[:shipping_detail][:question_response_id]
    @question_response = QuestionResponse.find(params[:shipping_detail][:question_response_id])
    
    @tos = params[:tos]
    
    @device = Device.new(:product => @product, :question_response => @question_response)
    @device.status_code = 0  
    if @device.valid?
      @device.save
    end
    
    # Take a snapshot of the initial offer
    #@shipping_detail.offer = @question_response.quote unless @question_response.nil?
    #@shipping_detail.final_offer = @question_response.quote unless @question_response.nil?    
    @device.offer         = @question_response.quote unless @question_response.nil?
    @device.final_offer   = @question_response.quote unless @question_response.nil?
    
    @shipping_detail.devices[0] = @device
    else
      @tos = params[:shipping_detail][:tos]
      logger.info "===========user id  #{session[:current_user]}"
      @shipping_detail.user_id=session[:current_user]
      
    end
    respond_to do |format|
      if @tos=='0' || @product.nil?
        flash[:error] = "You must first agree to the terms of service"
        format.html { render :action => "new", :product_id => @product.id,  :notice => "You must first agree to the terms of service" } #:question_response_id => @question_response.id,
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      elsif @shipping_detail.save
<<<<<<< HEAD
        
         params[:products][:product_list].collect{|i| @shipping_detail.other_details.create(:product_id => i.to_i) }

        #UserMailer.welcome_email(@shipping_detail).deliver
        #UserMailer.new_quote_request_email(@shipping_detail).deliver
        
        format.html { redirect_to "/showdata?id=#{@shipping_detail.id}", :list => @array, :notice => 'Please check your email for confirmation' }
        format.xml  { render :xml => shipping_detailsshow_data, :status => :created, :action => 'show_data',:params=>@array }
      else
        logger.info "===========user id  #{session[:current_user]}"
        format.html { render :action => "new", :product_id => @product.id }#, :question_response_id => @question_response.id
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      end
    end
    else
      flash[:error] = "Please select at least one product."
      redirect_to '/shipping_details/new?login=true'
    end
  end

def showdata
 logger.info "==============session in showdata #{@@var} "
  @shipping_detail = ShippingDetail.find(params[:id])
  @remainingData = @shipping_detail.other_details
  
  @array = @@var.collect{|i| Product.find(i)}
end

 def updatedata

    @shipping_detail = ShippingDetail.find(params[:id])
    @price_type = params[:product][:price_type]
    @product_id = params[:product][:product_id]
    @price_type.each_with_index do |price, index|

      @o_detail=@shipping_detail.other_details.where(:product_id => @product_id[index])
      @o_detail.each do |update|
        update.price_type = price
        update.save
      end
    end
    #session[:list] = nil
    respond_to do |format|
      format.html { redirect_to(shipping_details_path, :notice => 'Shipping detail was successfully updated.') }
      format.xml  { head :ok }
    end
  end
  
  
  # PUT /shipping_details/1
  # PUT /shipping_details/1.xml
  def update
    @shipping_detail = ShippingDetail.find(params[:id])

    respond_to do |format|
      if !params[:products].nil?
      params[:shipping_detail][:product_ids] = params[:products][:product_list]
      end
      if @shipping_detail.update_attributes(params[:shipping_detail])
                
        if !params[:products].nil?
                   
          @shipping_detail.other_details.each do |f|
            f.destroy
          end
                 
          @@var = params[:products][:product_list]          
          params[:products][:product_list].collect{|i| @shipping_detail.other_details.create(:product_id => i.to_i) }    
           
         
        # params[:products][:product_list].collect{|i| @shipping_detail.other_details.update_attribute(:product_id, i.to_i) }
        format.html { redirect_to "/showdata?id=#{@shipping_detail.id}", :list => @array, :notice => 'Please check your email for confirmation' }
        format.xml  { render :xml => shipping_detailsshow_data, :status => :created, :action => 'show_data',:params=>@array }
        
        else
        
        format.html { redirect_to(@shipping_detail, :notice => 'Shipping detail was successfully updated.') }
        format.xml  { head :ok }
        end
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
    @shipping_detail.other_details.destroy_all
    @shipping_detail.destroy

    respond_to do |format|
      format.html { redirect_to(shipping_details_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_return_label
    # USPS Spec
    # https://www.usps.com/webtools/_pdf/Electronic-Merchandise-Return-v10-0c.pdf
    
    shipping_detail = ShippingDetail.find(params[:id])
    print shipping_detail.inspect
    
    usps = USPS.new('835DEPST0103')
    
    customer_address = Location.new( 
      :name => shipping_detail.full_name,  
      :address1 => shipping_detail.address2, # Secondary address unit designator and number (such as an apartment or suite number (APT 202, STE 100)).
      :address2 => shipping_detail.address1, # Address of customer returning the package.
      :state => shipping_detail.state,
      :city => shipping_detail.city, 
      :zip5 => shipping_detail.zip
    )
    
    service_type = "Priority"
    customer = customer_address #Location.new( :name=> shipping_detail.full_name,  :address1 => shipping_detail.address1, :address2 => shipping_detail.address2, :state => shipping_detail.state, :city => shipping_detail.city, :zip5 => shipping_detail.zip)
    #customer = Location.new( :name=> "Charles Palleschi",  :address1 => "59 Rumney Rd.", :address2 => "59 Rumney Rd", :state => 'MA', :city => 'Revere', :zip5 => '02151')
    retailer = Location.new( :name=> "Depstar.com",  :address1 => "", :address2 =>"PO Box 55923", :state => 'MA', :city => 'Boston', :zip5 => '02205', :zip4 => '5923')
    permit_number = "104001"
    post_office = Location.new( :state => 'MA', :city => 'Boston', :zip5 => '02205')
    postage_delivery_unit =  Location.new( :name => 'Boston Post Office', :address2 =>"25 Dorchester Ave RM 1", :state => 'MA', :city => 'Boston', :zip5 => '02205', :zip4 => '9761')
    ounces = "1"
    options = {} #{:RMA => "13456", :insurance => "500", :confirmation => "true"}
    image_type = "PDF" # or "TIF"
    
    image = usps.merch_return(
      service_type,
      customer,
      retailer, 
      permit_number, 
      post_office, 
      postage_delivery_unit, 
      ounces, 
      image_type)

    unless image.kind_of?(String)
      send_data Base64.decode64(image[:label]), :type => image[:image_type], :disposition => "inline"
    else
      @usps = image
      render
    end
    
  end
  
  def create_shipping_label
    # http://www.stamps.com/pdk/downloads/files/Stamps.com_SWSIM_Reference.pdf
    
    @shipping_detail = ShippingDetail.find(params[:id])
    
    ship_date = Date.tomorrow.strftime('%Y-%m-%d')

    rates = Stamps.get_rates(
      :from_zip_code  => '02205',
      :to_zip_code    => @shipping_detail.zip,
      :weight_oz      => '2.0',
      :package_type   => 'Large Envelope or Flat',
      :service_type   => 'US-FC',  # Flat-rate
      :ship_date      => Date.tomorrow.strftime('%Y-%m-%d')
    )
    
    unless rates.nil?
      unless rates.first.nil?
        rates.first[:ship_date] = ship_date
      end
    end
    @rates = rates
    
    standardized_address = Stamps.clean_address(
    :address => {
      :full_name   => @shipping_detail.full_name,
      :address1    => @shipping_detail.address1,
      :address2    => @shipping_detail.address2,
      :city        => @shipping_detail.city,
      :state       => @shipping_detail.state,
      :zip_code    => @shipping_detail.zip
    })

    # @purchase = Stamps.purchase_postage(
    #       :amount => 200.3800,
    #       :control_total => 0.3800
    #     )
    
    # SC-A-HP  Stamps.com Hidden Postage Specifying Hidden Postage will generate a shipping 
    # label indicium that does not show the actual 
    # postage amount.  This option is useful for 
    # customers who wish to hide the actual postage 
    # amount from the recipients of packages.
    
    stamp = Stamps.create!(
      :rate          => {
        :from_zip_code  => '02205',
        :to_zip_code    => @shipping_detail.zip,
        :weight_oz      => '2.0',
        :package_type   => 'Large Envelope or Flat',
        :service_type   => 'US-FC',  # Flat-rate
        :ship_date      => Date.tomorrow.strftime('%Y-%m-%d'),
        :add_ons       => {
          :add_on => [
            { :type => 'SC-A-HP' }
          ]
        }
      },
      #:rate          => rates.first,
      :to            => standardized_address[:address],
      :from => {
        :full_name   => 'Depstar.com',
        :address1    => 'PO Box 55923',
        :city        => 'Boston',
        :state       => 'MA',
        :zip_code    => '02205'
      },
      :transaction_id => @shipping_detail.id,
      :tracking_number => true
    )
    # print stamp[:valid?]
    #    print 'test'
    #    print stamp.inspect
    #    if stamp[:valid?] = 'false'
    #      print 'this is false'
    #    end
       
    # if stamp[:valid?] == false or stamp[:valid?] == 'false' 
    #   @stamp = stamp
    #   render #:layout => false
    # else
    #   redirect_to stamp[:url] unless stamp[:url].nil?
    # end
    
    @stamp = stamp
    render :layout => false    
  end  


    @question_response = @shipping_detail.question_response
    @user = current_user
    
    #logger.debug "@question_response ----- " + ShippingDetail.find(params[:id]).inspect
    
    # @purchase = Stamps.purchase_postage(
    #   :amount => 100,
    #   :control_total => 200
    # )
    
    # stamps_local = Stamps.clone # Make local copy
    # #print 'stamps_local.inspect ---- ' + stamps_local.inspect + '----'
    # #print 'stamps_local.inspect ---- ' + stamps_local.inspect + '----'
    # #@available_postage = Stamps.account.inspect
    # unless stamps_local.blank?
    #   unless stamps_local.account.blank?
    #     unless stamps_local.account[:valid?] == false
    #       @available_postage = stamps_local.account[:postage_balance][:available_postage]
    #     end
    #   end
    # end
    
  end

  # POST /shipping_details
  # POST /shipping_details.xml
  def create
    @shipping_detail = ShippingDetail.new(params[:shipping_detail])
    
    @product = Product.find(params[:shipping_detail][:product_id])
    @question_response = QuestionResponse.find(params[:shipping_detail][:question_response_id])
    
    @tos = params[:tos]
    
    @device = Device.new(:product => @product, :question_response => @question_response)
    @device.status_code = 0  
    if @device.valid?
      @device.save
    end
    
    # Take a snapshot of the initial offer
    #@shipping_detail.offer = @question_response.quote unless @question_response.nil?
    #@shipping_detail.final_offer = @question_response.quote unless @question_response.nil?    
    @device.offer         = @question_response.quote unless @question_response.nil?
    @device.final_offer   = @question_response.quote unless @question_response.nil?
    
    @shipping_detail.devices[0] = @device
    
    respond_to do |format|
      if @tos.nil?
        flash[:error] = "You must first agree to the terms of service"
        format.html { render :action => "new", :product_id => @product.id, :question_response_id => @question_response.id, :notice => "You must first agree to the terms of service" }
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      elsif @shipping_detail.save
        UserMailer.welcome_email(@shipping_detail).deliver
        UserMailer.new_quote_request_email(@shipping_detail).deliver
=======
>>>>>>> 36d22b3f8a4d34a925bbe2af591862f92360caf9
        
         params[:products][:product_list].collect{|i| @shipping_detail.other_details.create(:product_id => i.to_i) }

        #UserMailer.welcome_email(@shipping_detail).deliver
        #UserMailer.new_quote_request_email(@shipping_detail).deliver
        
        format.html { redirect_to "/showdata?id=#{@shipping_detail.id}", :list => @array, :notice => 'Please check your email for confirmation' }
        format.xml  { render :xml => shipping_detailsshow_data, :status => :created, :action => 'show_data',:params=>@array }
      else
        format.html { render :action => "new", :product_id => @product.id, :question_response_id => @question_response.id }
        format.xml  { render :xml => @shipping_detail.errors, :status => :unprocessable_entity }
      end
    end
    else
      flash[:error] = "Please select at least one product."
      redirect_to '/shipping_details/new?login=true'
    end
  end

def showdata
 logger.info "==============session in showdata #{@@var} "
  @shipping_detail = ShippingDetail.find(params[:id])
  @remainingData = @shipping_detail.other_details
  
  @array = @@var.collect{|i| Product.find(i)}
end

 def updatedata

    @shipping_detail = ShippingDetail.find(params[:id])
    @price_type = params[:product][:price_type]
    @product_id = params[:product][:product_id]
    @price_type.each_with_index do |price, index|

      @o_detail=@shipping_detail.other_details.where(:product_id => @product_id[index])
      @o_detail.each do |update|
        update.price_type = price
        update.save
      end
    end
    #session[:list] = nil
    respond_to do |format|
      format.html { redirect_to(shipping_details_path, :notice => 'Shipping detail was successfully updated.') }
      format.xml  { head :ok }
    end
  end
  
  
  # PUT /shipping_details/1
  # PUT /shipping_details/1.xml
  def update
    @shipping_detail = ShippingDetail.find(params[:id])

    respond_to do |format|
      if !params[:products].nil?
      params[:shipping_detail][:product_ids] = params[:products][:product_list]
      end
      if @shipping_detail.update_attributes(params[:shipping_detail])
                
        if !params[:products].nil?
                   
          @shipping_detail.other_details.each do |f|
            f.destroy
          end
                 
          @@var = params[:products][:product_list]          
          params[:products][:product_list].collect{|i| @shipping_detail.other_details.create(:product_id => i.to_i) }    
           
         
        # params[:products][:product_list].collect{|i| @shipping_detail.other_details.update_attribute(:product_id, i.to_i) }
        format.html { redirect_to "/showdata?id=#{@shipping_detail.id}", :list => @array, :notice => 'Please check your email for confirmation' }
        format.xml  { render :xml => shipping_detailsshow_data, :status => :created, :action => 'show_data',:params=>@array }
        
        else
        
        format.html { redirect_to(@shipping_detail, :notice => 'Shipping detail was successfully updated.') }
        format.xml  { head :ok }
        end
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
    @shipping_detail.other_details.destroy_all
    @shipping_detail.destroy

    respond_to do |format|
      format.html { redirect_to(shipping_details_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_return_label
    # USPS Spec
    # https://www.usps.com/webtools/_pdf/Electronic-Merchandise-Return-v10-0c.pdf
    
    shipping_detail = ShippingDetail.find(params[:id])
    print shipping_detail.inspect
    
    usps = USPS.new('835DEPST0103')
    
    customer_address = Location.new( 
      :name => shipping_detail.full_name,  
      :address1 => shipping_detail.address2, # Secondary address unit designator and number (such as an apartment or suite number (APT 202, STE 100)).
      :address2 => shipping_detail.address1, # Address of customer returning the package.
      :state => shipping_detail.state,
      :city => shipping_detail.city, 
      :zip5 => shipping_detail.zip
    )
    
    service_type = "Priority"
    customer = customer_address #Location.new( :name=> shipping_detail.full_name,  :address1 => shipping_detail.address1, :address2 => shipping_detail.address2, :state => shipping_detail.state, :city => shipping_detail.city, :zip5 => shipping_detail.zip)
    #customer = Location.new( :name=> "Charles Palleschi",  :address1 => "59 Rumney Rd.", :address2 => "59 Rumney Rd", :state => 'MA', :city => 'Revere', :zip5 => '02151')
    retailer = Location.new( :name=> "Depstar.com",  :address1 => "", :address2 =>"PO Box 55923", :state => 'MA', :city => 'Boston', :zip5 => '02205', :zip4 => '5923')
    permit_number = "104001"
    post_office = Location.new( :state => 'MA', :city => 'Boston', :zip5 => '02205')
    postage_delivery_unit =  Location.new( :name => 'Boston Post Office', :address2 =>"25 Dorchester Ave RM 1", :state => 'MA', :city => 'Boston', :zip5 => '02205', :zip4 => '9761')
    ounces = "1"
    options = {} #{:RMA => "13456", :insurance => "500", :confirmation => "true"}
    image_type = "PDF" # or "TIF"
    
    image = usps.merch_return(
      service_type,
      customer,
      retailer, 
      permit_number, 
      post_office, 
      postage_delivery_unit, 
      ounces, 
      image_type)

    unless image.kind_of?(String)
      send_data Base64.decode64(image[:label]), :type => image[:image_type], :disposition => "inline"
    else
      @usps = image
      render
    end
    
  end
  
  def create_shipping_label
    # http://www.stamps.com/pdk/downloads/files/Stamps.com_SWSIM_Reference.pdf
    
    @shipping_detail = ShippingDetail.find(params[:id])
    
    ship_date = Date.tomorrow.strftime('%Y-%m-%d')

    rates = Stamps.get_rates(
      :from_zip_code  => '02205',
      :to_zip_code    => @shipping_detail.zip,
      :weight_oz      => '2.0',
      :package_type   => 'Large Envelope or Flat',
      :service_type   => 'US-FC',  # Flat-rate
      :ship_date      => Date.tomorrow.strftime('%Y-%m-%d')
    )
    
    unless rates.nil?
      unless rates.first.nil?
        rates.first[:ship_date] = ship_date
      end
    end
    @rates = rates
    
    standardized_address = Stamps.clean_address(
    :address => {
      :full_name   => @shipping_detail.full_name,
      :address1    => @shipping_detail.address1,
      :address2    => @shipping_detail.address2,
      :city        => @shipping_detail.city,
      :state       => @shipping_detail.state,
      :zip_code    => @shipping_detail.zip
    })

    # @purchase = Stamps.purchase_postage(
    #       :amount => 200.3800,
    #       :control_total => 0.3800
    #     )
    
    # SC-A-HP  Stamps.com Hidden Postage Specifying Hidden Postage will generate a shipping 
    # label indicium that does not show the actual 
    # postage amount.  This option is useful for 
    # customers who wish to hide the actual postage 
    # amount from the recipients of packages.
    
    stamp = Stamps.create!(
      :rate          => {
        :from_zip_code  => '02205',
        :to_zip_code    => @shipping_detail.zip,
        :weight_oz      => '2.0',
        :package_type   => 'Large Envelope or Flat',
        :service_type   => 'US-FC',  # Flat-rate
        :ship_date      => Date.tomorrow.strftime('%Y-%m-%d'),
        :add_ons       => {
          :add_on => [
            { :type => 'SC-A-HP' }
          ]
        }
      },
      #:rate          => rates.first,
      :to            => standardized_address[:address],
      :from => {
        :full_name   => 'Depstar.com',
        :address1    => 'PO Box 55923',
        :city        => 'Boston',
        :state       => 'MA',
        :zip_code    => '02205'
      },
      :transaction_id => @shipping_detail.id,
      :tracking_number => true
    )
    # print stamp[:valid?]
    #    print 'test'
    #    print stamp.inspect
    #    if stamp[:valid?] = 'false'
    #      print 'this is false'
    #    end
       
    # if stamp[:valid?] == false or stamp[:valid?] == 'false' 
    #   @stamp = stamp
    #   render #:layout => false
    # else
    #   redirect_to stamp[:url] unless stamp[:url].nil?
    # end
    
    @stamp = stamp
    render :layout => false
    
  end
  
end
