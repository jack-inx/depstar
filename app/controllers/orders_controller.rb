class OrdersController < ApplicationController
  layout 'affiliate_layout'

  before_filter :authorize, :except => [:show]
  # GET /manufacturers
  # GET /manufacturers.xml
  def index
    @user = User.find(session[:current_user])
    if !params[:q].nil?
      if !params[:q][:name_contains].nil?
        @orders = Order.where("first_name LIKE ? AND user_id = ? and status = ?","%#{params[:q][:name_contains]}%", session[:current_user], true)
      else
        @orders = Order.where(:created_at =>(("#{params[:q][:created_at_gte]}")..("#{params[:q][:created_at_lte]}")),:user_id => session[:current_user],:status => true )
      end
    else
      @orders = Order.where(:user_id => session[:current_user], :status => true)
      @order_index = "current"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /manufacturers/new
  # GET /manufacturers/new.xml
  def new
    @order = Order.new
    #@series_list = SeriesList.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @order = Order.find(params[:id])
    p "==============================#{@order.products.name}============================="
    @product_order_list = @order.products
    @product_list = @order.products.first
    if @product_list.category.name  == "iPhones" || @product_list.category.name == "iPad" || @product_list.category.name == "iPod"
          @name = "Product list"
        elsif @product_list.category.name == "Tablet"
          @name = "Manufacturer List"
        else
          @name = "Brand List"
        end
    p "==============================#{@product_list.category}============================="
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        logger.info "6666666666666666666666666666666#{params[:products][:price]}"
        OrderProductPriceType.where(:order_id => @order.id).delete_all

        params[:products][:product_id].each_with_index do |product,index|
          OrderProductPriceType.create(:order_id => @order.id,
          :product_id => params[:products][:product_id][index],
          :price_type_id => params[:products][:product_price_type][index],
          :price => params[:products][:price][index] )
        end

        format.html { redirect_to("/orders", :notice => 'Please Select Price Type for each product.') }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        #logger.info "6666666666666666666666666666666#{params[:products][:price]}"

        OrderProductPriceType.where(:order_id => @order.id).delete_all

        params[:products][:product_id].each_with_index do |product,index|
          OrderProductPriceType.create(:order_id => @order.id,
          :product_id => params[:products][:product_id][index],
          :price_type_id => params[:products][:product_price_type][index],
          :price => params[:products][:price][index] )
        end
        format.html { redirect_to("/orders", :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    OrderProductPriceType.where(:order_id => @order.id).delete_all

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  def add_price_type
    @order = Order.find(params[:order])
  end

  def submit_price_type
    OrderProductPriceType.where(:order_id => params[:order_id]).delete_all
    params[:products][:product_id].each_with_index do |product,index|
      OrderProductPriceType.create(:order_id => params[:order_id],
      :product_id => params[:products][:product_id][index],
      :price_type_id => params[:products][:product_price_type][index],
      :price => params[:products][:price][index] )
    end
    redirect_to "/orders"
  end

  def update_versions
    @series_list = Array.new
    @carrier_list = Array.new
    @user = User.find(params[:user])
    if params[:type].eql?("category")
      
      if !params[:category_name].nil?
      @category_name = params[:category_name]
        @category = Category.find_by_name(params[:category_name])
        
        if params[:category_name] == "iPhones" || params[:category_name] == "iPad" || params[:category_name] == "iPod"
          @name = "Product list"
        elsif params[:category_name] == "Tablet"
          @name = "Manufacturer List"
        else
          @name = "Brand List"
        end
        
        @series_new = @user.products.find_all_by_category_id(@category)
        if params[:category_name] == "Tablet"
          @series_new.each do |i|
            @series_list << i.manufacturer.name
          end
        else
          @series_new.each do |i|
            @series_list << i.series_list.name
          end          
        end
      end
      respond_to do |format|
        format.js
      end
    end

  end

  def update_versions_for_series
    @carrier_list = Array.new
    @product_list = Hash.new
    @category_name = params[:type]
    @user = User.find(params[:user])
    @series_name = params[:series]
    if @category_name == "Tablet"
      @manufacturer = Manufacturer.find_by_name(@series_name)
      @category = Category.find_by_name(@category_name)
      @series = @user.products.find_all_by_manufacturer_id_and_category_id(@manufacturer.id.to_s,@category.id.to_s)
      @series.each do |p|
        @product_list["#{p.name}"] = "#{p.id}"
      end
    else    
      @series_list = SeriesList.find_by_name(params[:series])
      @series = @user.products.find_all_by_series_list_id(@series_list)
      @series.each do |p|
        @carrier_list << p.carrier.name
        @product_list["#{p.name}"] = "#{p.id}"
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def update_versions_for_carrier
    @carrier_list = Array.new
    @product_list = Hash.new
    @user = User.find(params[:user])
    @series_new = SeriesList.find_by_name(params[:type])
    @carrier = Carrier.find_by_name(params[:carrier])
    @series = @user.products.find_all_by_carrier_id_and_series_list_id(@carrier.id.to_s,@series_new.id.to_s)
   # @series = @user.products.find(:all, :conditions => ["carrier_id = ? AND series_list_id = ?",@carrier,@series_new])
    @series.each do |p|
      @carrier_list << p.carrier.name
      @product_list["#{p.name}"] = "#{p.id}"
    end
    respond_to do |format|
      format.js
    end    
  end

  def update_versions_for_prices
    @user = User.find(params[:user])
    @product_list = @user.products.find(params[:product_id])
    respond_to do |format|
      format.js
    end
  end
  
  def order_list
    if !params[:q].nil? and !params[:s].nil?      
      @orders = Order.where(:user_id => session[:current_user], :status => true).order("#{params[:q]} #{params[:s]}")
    else
      @orders = Order.where(:user_id => session[:current_user], :status => true)
    end
    render "index"    
  end

  def search_filter
    @user = User.find(session[:current_user])
    if params[:search][:date].blank?
      @orders = Order.where("first_name LIKE ? AND last_name LIKE ? AND order_id LIKE ? AND email LIKE ? AND status = ?",
      "%#{params[:search][:first_name]}%", "%#{params[:search][:last_name]}%", "%#{params[:search][:purchase_order]}%", "%#{params[:search][:user_name]}%",true)    
    else
      @orders = Order.where("first_name = ? AND last_name = ? AND order_id = ? OR Date(created_at) = Date(?) AND email LIKE ? and status = ?",
      "%#{params[:search][:first_name]}%", "%#{params[:search][:last_name]}%", "%#{params[:search][:purchase_order]}%",params[:search][:date], "%#{params[:search][:user_name]}%",true)
    end
    
    if !params[:search][:payment_product].blank?
      @product_name = Product.find_by_name(params[:search][:payment_product])
      @product_list = @user.products.find(@product_name)
      @orders << @product_list.orders
    end
    if !params[:search][:payment_carrier].blank?
      @carrier_name = Carrier.find_by_name(params[:search][:payment_carrier])
      @carrier_list = @user.products.find_all_by_carrier_id(@carrier_name)
      @orders << @carrier_list
    end

    @orders.flatten!
    render "index"
  end
  
  def order_by_sub_affiliates
    @users = User.where("user_id = ? or id = ? ", session[:current_user],  session[:current_user])
    @orders = Array.new
    
    @users.each do |user|
       @orders << Order.where(:user_id => user.id, :status => true)            
    end  
    
    @order_index_sub_affilaites = "current"
    @orders = @orders.flatten!
    
    render "index"
  end
  
  def sub_affiliates
    if !params[:q].nil? and !params[:q][:username].nil? 
      @users = User.where("email LIKE ? and is_affiliate_admin = ? ","%#{params[:q][:username]}%",false)
    else
      @users = User.where(:user_id => session[:current_user], :is_affiliate_admin => false)    
    end   
    @sub_affiliates = "current"
    #logger.info "#{@orders.inspect}"
    render "affiliate_index"
  end
  
  def new_sub_affiliates
    @user = User.new
    
    render "affiliate_new"
  end
  
  def create_sub_affiliates
    @user = User.new(params[:user])
    @user.is_affiliate_admin = params[:is_affiliate_admin]
    @user.user_id = params[:user_id]
    
    if @user.save
      #flash[:notice] = "Registration successful."
      redirect_to "/affiliates/users"
    else
      render :action => 'affiliate_new'
    end
        
    #render "affiliate_show"
  end
  
  def show_sub_affiliates
    @user = User.find(params[:id]) 
    
    render "affiliate_show"
  end
  
  def edit_sub_affiliates
    @user = User.find(params[:id]) 
    
    render "affiliate_edit"
  end
    
  def update_sub_affiliates
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      
      redirect_to "/affiliates/users"
    else
      render :action => 'affiliate_edit'
    end  
  end
  
  def delete_sub_affiliates 
    @user = User.find(params[:id])
    #@user.destroy
    @users = User.where(:user_id => session[:current_user], :is_affiliate_admin => false)
        
    render "affiliate_index"
  end
   
  def order_pricing    
    @user = User.find(session[:current_user])
    @order_pricing = "current"     
    render "order_prices"     
  end
  
  def cancel_order
    if !params[:id].nil?
      @order = Order.find(params[:id])
      @order.status = false
      @order.save      
    end  
    @orders = Order.where(:user_id => session[:current_user], :status => true)
    
    render "index"
  end
end
