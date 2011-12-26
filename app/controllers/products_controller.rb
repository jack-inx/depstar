class ProductsController < ApplicationController
  before_filter :authorize, :except => [:show, :get_quote, :accept_quote, :index, :search]
  before_filter :xml_authorize, :include => [:index]
  
  # GET /products
  # GET /products.xml
  def index
	  unless(params[:popular] == 'true')
  		@products = Product.all
  	else	
  		@products = Product.find_all_by_is_popular(true)
  	end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  # { render :xml => @products }
    end
  end
  
  def search
    #debugger
    @products = Product.where("name like '%"+params[:name]+"%'").paginate(:page => params[:page])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @products }
    end
  end
  
  def get_quote
    @question_response = QuestionResponse.new(params[:question_response])
       
    if @question_response.valid?
      flash[:error] = nil
    else
      flash[:error] = "Please answer all questions"
    end
    
    respond_to do |format|
      format.js
      format.xml  { render :xml => @question_response }
    end
  end
  
  def accept_quote
    @question_response = QuestionResponse.new(params[:question_response])
    
    @question_4_params = params[:question_response][:question_4]
	  @question_4 = @question_4_params.join(", ") if @question_4_params
    
    @question_response.question_4 = @question_4
    
    if @question_response.save
      redirect_to new_shipping_detail_path(:shipping_detail => {:question_response_id => @question_response.id, :product_id => @question_response.product_id})
    else
      redirect_to product_path(params[:question_response][:product_id])
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    @question_response = QuestionResponse.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
    @categories = Category.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @categories = Category.find(:all)    
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
end