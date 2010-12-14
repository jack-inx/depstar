class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  
  def get_quote
    
    @product = Product.find(params[:id])
    #debugger
    
    @quote = @product.price
    
    unless params[:question_1].blank?      
      if params[:question_1] == "True"
        @quote *= @product.category.question_1_option_1_multiplier
      elsif params[:question_1] == "False"
        @quote *= @product.category.question_1_option_2_multiplier
      end      
    end
    
    unless params[:question_2].blank?      
      if params[:question_2] == "True"
        @quote *= @product.category.question_2_option_1_multiplier
      elsif params[:question_2] == "False"
        @quote *= @product.category.question_2_option_2_multiplier
      end      
    end
        
    unless params[:question_3].blank?      
      if params[:question_3] == "1"
        @quote *= @product.category.question_3_option_1_multiplier
      elsif params[:question_3] == "2"
        @quote *= @product.category.question_3_option_2_multiplier
      elsif params[:question_3] == "3"
        @quote *= @product.category.question_3_option_3_multiplier        
      elsif params[:question_3] == "4"
        @quote *= @product.category.question_3_option_4_multiplier
      end
    end
    
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

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
