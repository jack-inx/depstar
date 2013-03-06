class ManufacturersController < ApplicationController
  before_filter :authorize,:except => [:manufacturer_carrier, :show_sub_category]
  #add_breadcrumb "Manufacturer", :root_path
  
  # GET /manufacturers
  # GET /manufacturers.xml
  def index
    @manufacturers = Manufacturer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @manufacturers }
    end
  end

  def manufacturer_carrier
    @category = Category.find(params[:cid])
     
    if !@category.name.include?('Tablet')  
      if !params[:mid].nil?
        @manufacturers = Manufacturer.find(params[:mid])
        @title_line = "Sell Your #{@manufacturers.name} #{@category.name} - Depstar"
      elsif !params[:sid].nil?
        @series_list = SeriesList.find(params[:sid])
        if !@category.name.include?("iPhone")
          @title_line = "Sell Your #{@category.name} #{@series_list.name} - Depstar"
        else
          @title_line = "Sell Your #{@series_list.name} - Depstar"
        end        
      end
    else
      @manufacturers = Manufacturer.find(params[:mid])
      @products = @category.products.where(:manufacturer_id => params[:mid] )
      @title_line = "Sell Your #{@manufacturers.name} #{@category.name} - Depstar"
    end   
                 
  end


  # GET /manufacturers/1
  # GET /manufacturers/1.xml
  def show
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/new
  # GET /manufacturers/new.xml
  def new
    @manufacturer = Manufacturer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])


    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to(@manufacturer, :notice => 'Manufacturer was successfully created.') }
        format.xml  { render :xml => @manufacturer, :status => :created, :location => @manufacturer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.xml
  def update
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      if @manufacturer.update_attributes(params[:manufacturer])
        format.html { redirect_to(@manufacturer, :notice => 'Manufacturer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.xml
  def destroy
    @manufacturer = Manufacturer.find(params[:id])
    @manufacturer.destroy

    respond_to do |format|
      format.html { redirect_to(manufacturers_url) }
      format.xml  { head :ok }
    end
  end
  
  def show_sub_category
    if !params[:category].nil?      
      @c = Category.where("name LIKE ?","%#{params[:category].gsub("-"," ")}%")
      @category = @c.first
    end
    
    if !params[:sub_category].nil?    
      if @category.name.include?('Tablet') or @category.name.include?('Cell Phone')
        
        
        if params[:sub_category].include?("#{params[:category]}")
          params[:sub_category].gsub("#{params[:category]}","")
        end
        @manufacturers = Manufacturer.where("name LIKE ?","%#{params[:sub_category].gsub("-"," ")}%").first
        
        if @category.name.include?('Tablet')
          
        end  
        # if !params[:sub_category].nil?
          # @manufacturers = Manufacturer.find(params[:sub_category])
          # @title_line = "Sell Your #{@manufacturers.name} #{@category.name} - Depstar"
        # elsif !params[:sid].nil?
          # @series_list = SeriesList.find(params[:sid])
          # if !@category.name.include?("iPhone")
            # @title_line = "Sell Your #{@category.name} #{@series_list.name} - Depstar"
          # else
            # @title_line = "Sell Your #{@series_list.name} - Depstar"
          # end        
        # end
      else
                
        if params[:sub_category].include?("#{params[:category]}") and !params[:sub_category].include?("iphone") 
          params[:sub_category] = params[:sub_category].gsub("#{params[:category]}-","")
        end
        
        @series_list = SeriesList.where("name LIKE ?","%#{params[:sub_category].gsub("-"," ")}%").first
        
        #@manufacturers = Manufacturer.find(params[:mid])
        #@products = @category.products.where(:manufacturer_id => params[:mid] )
        #@title_line = "Sell Your #{@manufacturers.name} #{@category.name} - Depstar"
      end
    end
    
    render "show_sub_category"
  end
end
