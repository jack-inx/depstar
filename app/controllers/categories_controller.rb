class CategoriesController < ApplicationController
  
  before_filter :authorize, :except => [:index, :show, :grades, :search_filter,:get_search_result, :carrier_product]
  before_filter :xml_authorize, :include => [:index, :grades]
  #add_breadcrumb "Categories", :root_path

  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.all
    #@usell_categories = Category.group('usell_category_code').find(:all, :conditions => "usell_category_code IS NOT NULL")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  #{ render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml 


  def show
    @category = Category.find(params[:id])
    @products = @category.products #.paginate(:page => params[:page])

    @manufacturer_list = @category.manufacturers

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end
 
  def grades
    
    unless params[:id].nil?
      @product = Product.find(:all, :include => [:category], :conditions=> ['categories.usell_category_code = ?', params[:id]]).first
    else
      @product = nil
    end
    
    respond_to do |format|
      #format.html # show.html.erb
      format.xml #{ render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    @manufacturers = Manufacturer.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @manufacturers = Manufacturer.all

  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to(@category, :notice => 'Category was successfully created.') }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
    

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(@category, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_manufacturer

    if params[:field].eql?("category")
       @category = Category.find(params[:id])
       @data = @category.manufacturers
          
    elsif params[:field].eql?("manufacturer")
       @manufacturer = Manufacturer.find(params[:id])
       @data = @manufacturer.carriers
    end   
    
    respond_to do |format|
      format.json { render :json => @data }

    end
  end
  
  
  def search_filter
    @category = Category.find(params[:id])
        
    if @category.manufacturers.first.name.include?("Apple")
      @apple_product = true   
      #logger.info "# apple product #{@apple_product}   ####"   
    end      
  end  
  
  def get_search_result
     @product = Product.find_by_name(params[:name])
     logger.info "66666666666666666#{@product.inspect}6666666666"
     
     if @product.nil? 
       @products = Product.where("name LIKE ?","%#{params[:name]}%")
              
       if @products.size >= 1
          @series = @products.first.series_list
          @category = @products.first.category
          @manufacturer = @products.first.manufacturer
          @carrier = @products.first.carrier
          
          render "categories/carrier_product"          
        else
           redirect_to root_url
       end
     else
      render "products/show"                
     end     
     
  end
  
  def carrier_product
    @category = Category.find(params[:cid])
    @carrier = Carrier.find(params[:carrier_id]) 
    
    if !params[:series_id].nil?
      @products = Product.where(:category_id => params[:cid],:carrier_id => params[:carrier_id],:series_list_id => params[:series_id])
      @series = SeriesList.find(params[:series_id])
    else
      @products = Product.where(:category_id => params[:cid],:carrier_id => params[:carrier_id],:manufacturer_id => params[:mid])
      @manufacturer = Manufacturer.find(params[:mid])
    end    
        
  end
end
