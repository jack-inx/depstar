class ProductsController < ApplicationController
  before_filter :authorize, :except => [:show, :get_quote, :accept_quote, :index, :search, :offer]
  before_filter :xml_authorize, :include => [:index, :offer]
  
  # GET /products
  # GET /products.xml
  def index
    if params[:popular] == 'true'
  		@products = Product.find_all_by_is_popular(true)
  	elsif !params[:category_id].nil?
      Category.find_all_by_usell_category_code(params[:category_id]).each do |category|        
        if @products.nil?
          @products = category.products
        else
          @products += category.products
        end
      end
  	else
  		@products = Product.all
  	end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  # { render :xml => @products }
    end
  end
  

  def search
    @products = Product.where("name like '%#{params[:name]}%'") #.paginate(:page => params[:page])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @products }
    end
  end
  
  def offer
    @options = ''
    @params_to_pass_to_shipping_details = {}
    
    @product = Product.find(params[:id])
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
    
    @product = Product.find(params[:id])
    @question_response = QuestionResponse.new(:product_id => params[:id], 
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
      @params_to_pass_to_shipping_details['product_id'] = @product.id
      @product_link = new_shipping_detail_url(@params_to_pass_to_shipping_details)
    else
      @product_link = product_path(params[:question_response][:product_id])
    end
    
    respond_to do |format|
      format.html # offer.html.erb
      format.xml  # offer.xml.builder
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
    #@title_line = "Sell your "+ @product.name + " - Depstar"
    if @product.series_list 
      if !@product.series_list.name.include?("iPhone")
        @title_line = "Sell Your Used or Broken #{@product.manufacturer.name}  #{@product.category.name} #{@product.series_list.name} #{@product.name}- Depstar"
      else
        @title_line = "Sell Your Used or Broken #{@product.name}- Depstar"
      end      
    else
      if @product.category.name.include?("Tablet")
        @title_line = "Sell Your Used or Broken #{@product.manufacturer.name} #{@product.name}- Depstar"  
      else        
        @title_line = "Sell Your Used or Broken #{@product.name}- Depstar"
      end
      
    end    
    
    if params[:question_response].nil?
      @question_response = QuestionResponse.new  
    else
      @question_response = QuestionResponse.new(params[:question_response])
    end
    
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
    @carriers = Carrier.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @categories = Category.find(:all)    
    @carriers = Carrier.find(:all)
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