class SeriesListsController < ApplicationController
  # GET /series_lists
  # GET /series_lists.json
  def index
    @series_lists = SeriesList.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json:@series_lists }
    end
  end

  # GET /series_lists/1
  # GET /series_lists/1.json
  def show
    @series_list = SeriesList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @series_list }
    end
  end

  # GET /series_lists/new
  # GET /series_lists/new.json
  def new
    @series_list = SeriesList.new
    @categories = Category.where(:name => ['iPhones', 'iPod','iPad'])
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @series_list }
    end
  end

  # GET /series_lists/1/edit
  def edit
    @series_list = SeriesList.find(params[:id])
    @categories = Category.where(:name => ['iPhones', 'iPod','iPad'])
  end

  # POST /series_lists
  # POST /series_lists.json
  def create
    @series_list = SeriesList.new(params[:series_list])

    respond_to do |format|
      if @series_list.save
        format.html { redirect_to @series_list, notice: 'Series list was successfully created.' }
        format.json { render json: @series_list, status: :created, location: @series_list }
      else
        format.html { render action: "new" }
        format.json { render json: @series_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /series_lists/1
  # PUT /series_lists/1.json
  def update
    @series_list = SeriesList.find(params[:id])

    respond_to do |format|
      if @series_list.update_attributes(params[:series_list])
        format.html { redirect_to @series_list, notice: 'Series list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @series_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /series_lists/1
  # DELETE /series_lists/1.json
  def destroy
    @series_list = SeriesList.find(params[:id])
    @series_list.destroy

    respond_to do |format|
      format.html { redirect_to series_lists_url }
      format.json { head :no_content }
    end
  end
end
