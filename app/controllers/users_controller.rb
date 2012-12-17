class UsersController < ApplicationController
  
  #before_filter :authorize
  
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
    
    
   def product_prices
     @user = User.find(params[:id])
     
     #logger.info "$$$$$$$$$$$$$$$$$$$$$$ #{@user.crypted_password}  $$$$$$$$$$$$$$$$$$$$$$$$"
     respond_to do |format|
       format.html {render "admin/users/product_prices", :layout => 'admin' }
     end     
   end
   
   def suggest_prices
     @user = User.find(params[:user_id])
     #logger.info "$$$$$$$$$$$$$$$$$$$$$$ #{@user.crypted_password}  $$$$$$$$$$$$$$$$$$$$$$$$"
     @suggestion = Suggestion.where(:user_id => params[:user_id])
     
     if @suggestion.blank?
       UserMailer.welcome_affiliate_email(@user.username, @user.crypted_password, @user.email).deliver
     else
       UserMailer.affiliate_password_email(@user.username, @user.crypted_password, @user.email).deliver       
     end    
       
     params[:affiliates][:product_id].each_with_index do |product,index|
       Suggestion.create(:user_id => params[:user_id],
       :product_id => params[:affiliates][:product_id][index],
       :used_price => params[:affiliates][:used_price][index],
       :broken_price => params[:affiliates][:broken_price][index] )
     end
          
     redirect_to "/admin/users/#{params[:user_id]}"     
   end
end
