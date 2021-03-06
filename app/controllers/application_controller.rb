class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user 
  
  #before_filter :check_subdomain
  
  private
  
  def check_subdomain
    user_exist = false
    
    if request.subdomain.present? && request.subdomain != "www"
      User.select("email").each do |user| 
        if user.email.split('@').first.eql?(request.subdomain)
          user_exist = true        
        end 
      end
      
      if !user_exist
        redirect_to root_url(:host => request.domain)
        logger.info "inside loop"
      end      
    end    
  end
  
  def authorize
     unless current_user    
       flash[:notice] = 'Please log in'
       redirect_to(root_url)
     end
  end

   def current_user_session
     return @current_user_session if defined?(@current_user_session)
     @current_user_session = UserSession.find
   end

  def current_user
    if !session[:current_user].nil?
      true
    else
      nil
    end
    #return @current_user if defined?(@current_user)
    #@current_user = current_user_session && current_user_session.record
  end
  
  def xml_authorize
    if request.format == Mime::XML
      authenticate_or_request_with_http_basic do |username, password|
        (username == 'depstar1' && password == 'wonderland') || (username == 'depstar2' && password == 'maverick')
      end
    end
  end
  
end
