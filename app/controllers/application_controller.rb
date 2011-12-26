class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user

  private
  
  def authorize
    unless User.find_by_id(session['user_credentials_id'])    
      flash[:notice] = 'Please log in'
      redirect_to(login_path)
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def xml_authorize
    if request.format == Mime::XML
      authenticate_or_request_with_http_basic do |username, password|
        (username == 'depstar1' && password == 'wonderland') || (username == 'depstar2' && password == 'maverick')
      end
    end
  end
  
end
