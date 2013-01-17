class CarriersController < ApplicationController
   before_filter :authorize
  
  # GET /manufacturers
  # GET /manufacturers.xml
  def index
    @carriers = Carrier.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carriers }
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.xml
  def show
    @carrier = Carrier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @carrier }
    end
  end

  # GET /manufacturers/new
  # GET /manufacturers/new.xml
  def new
    @carrier = Carrier.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @carrier }
    end
  end

  # GET /manufacturers/1/edit
  def edit
    @carrier = Carrier.find(params[:id])
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @carrier = Carrier.new(params[:carrier])


    respond_to do |format|
      if @carrier.save
        format.html { redirect_to(@carrier, :notice => 'Manufacturer was successfully created.') }
        format.xml  { render :xml => @carrier, :status => :created, :location => @carrier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @carrier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.xml
  def update
    @carrier = Carrier.find(params[:id])

    respond_to do |format|
      if @carrier.update_attributes(params[:carrier])
        format.html { redirect_to(@carrier, :notice => 'Manufacturer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @carrier.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.xml
  def destroy
    @carrier = Carrier.find(params[:id])
    @carrier.destroy

    respond_to do |format|
      format.html { redirect_to(carriers_url) }
      format.xml  { head :ok }
    end
  end
end
