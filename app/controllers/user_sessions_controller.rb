class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    #@user = User.find(params[:user_session][:username])
    @user_session = UserSession.new(params[:user_session])
    @user = UserSession.check(params[:user_session][:username], params[:user_session][:password])
    
    if !@user.eql?(false)
     
      if User.checkStatus(params[:user_session][:username],params[:user_session][:password])
        session[:current_user] = @user      
        redirect_to "/orders"
      else
        flash[:notice] = "This account is inactive. Please contact to administrator."
        session[:current_user] = nil
        render :action => :new
      end
      
    else
      flash[:notice] = "Incorrect username or password."
      render :action => 'new'
    end
  end

  def destroy
    #@user_session = UserSession.find(session[:current_user])
    #@user_session.destroy unless @user_session.nil?
    session[:current_user] = nil
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
  
  def checkStatus(username,password)
    
  end
  
  def admin_as_affiliate
    session[:current_user] = User.find(params[:id]).id
    session[:admin] = true

    redirect_to "/profiles/#{Profile.find_by_user_id(params[:id]).id}"
  end
  
  def admin_logout_as_affiliate
     back_url = "/admin/users/#{session[:current_user]}"
    session[:current_user] = nil
    session[:admin] = false
    redirect_to back_url

    redirect_to "/shipping_details"
  end  
 
end
