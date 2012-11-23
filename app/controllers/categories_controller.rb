class CategoriesController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :grades, :search_filter, :carrier_product]
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

  def search_filter
    @category = Category.find(params[:id])
    @products = @category.products #.paginate(:page => params[:page])

    @manufacturer_list = @category.manufacturers

  end    


  def show
    @category = Category.find(params[:id])
    @products = @category.products #.paginate(:page => params[:page])

    @manufacturer_list = @category.manufacturers

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  #def manufacturer_carrier
    #add_breadcrumb "Manufacturer", :root_path, :title => "Manufacturer"
    #add_breadcrumb "index", index_path, :title => "Back to the Index"
  #  @manufacturers = Manufacturer.find(params[:manufact_id])
  #  @carriers =  @manufacturers.carriers
  #  session[:manufact_id] = params[:manufact_id]

    #@products = Product.where(:manufacturer_id => params[:id],:category_id => params[:cat_id])
    #@products = Product.final_product(params[:cat_id],params[:id])
  #end

  def carrier_product
    #add_breadcrumb "Carrier", :root_path

    @products = Product.where(:manufacturer_id => session[:manufact_id],:category_id => params[:cat_id],:carrier_id => params[:id])

    #@products = Product.final_product(params[:cat_id],params[:id])
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
    @category = Category.find(params[:id])
    @manufacturers = @category.manufacturers
    
    respond_to do |format|
      format.json { render :json => @manufacturers }
    end
  end
end
