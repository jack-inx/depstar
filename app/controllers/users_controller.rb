class UsersController < ApplicationController
  
  #before_filter :authorize, :only => [:index, :destroy]  
  
  def index
      @users = User.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to admin_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    if params[:id].nil? || params[:id] == "current"
      @user = current_user
    else
      @user = User.find(params[:id])      
    end     
        
  end
  
  def update
    
    if params[:id].empty? || params[:id] == "current"
      @user = current_user
    else
      @user = User.find(params[:id])
    end
        
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to admin_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
      @user = User.find(params[:id])
      @user.destroy
  
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    end
end
