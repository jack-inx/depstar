class ProfilesController < ApplicationController
  
  before_filter :check_current_user, :only =>[:edit, :update, :show]
  #before_filter :not_allowed
  
  def index
    @profiles = Profile.all
  end
  
  def new
    @profile = Profile.new
  end
  
  def show
    @profile = Profile.find(params[:id]) 
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
   @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(@profile, :notice => 'Profile successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end
 
 private
 
 def check_current_user
   if !current_user
     flash[:notice] = "Please Sign in to continue"
     redirect_to root_url
   end
 end
 
end
