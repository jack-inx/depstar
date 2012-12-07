class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    #@user = User.find(params[:user_session][:username])
    @user_session = UserSession.new(params[:user_session])
    @user = UserSession.check(params[:user_session][:username], params[:user_session][:password])
    
    if !@user.eql?(false)
      session[:current_user] = @user      
      redirect_to "/shipping_details"
    else
      flash[:notice] = "Successfully logged in."
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
end
