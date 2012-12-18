class OrdersController < ApplicationController
  layout 'affiliate_layout' 
  
  before_filter :authorize
  # GET /manufacturers
  # GET /manufacturers.xml
  def index
    
    if !params[:q].nil?      
      if !params[:q][:name_contains].nil?
        @orders = Order.where("first_name LIKE ? AND user_id = ?","%#{params[:q][:name_contains]}%", session[:current_user])
      else
        @orders = Order.where(:created_at =>(("#{params[:q][:created_at_gte]}")..("#{params[:q][:created_at_lte]}")),:user_id => session[:current_user] )  
      end      
    else
      @orders = Order.where(:user_id => session[:current_user])
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to("/product_price?order=#{@order.id}", :notice => 'Please Select Price Type for each product.') }
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
        format.html { redirect_to("/product_price?order=#{@order.id}", :notice => 'Order was successfully updated.') }
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
end
