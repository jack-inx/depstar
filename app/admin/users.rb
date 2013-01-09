ActiveAdmin.register User do  
  menu :priority => 1,:label => "Affiliates"  
  
 index do                           
    #column :username                     
    column "Username", :email, :sortable => false
    column :crypted_password, :sortable => false
    column :created_at, :sortable => false
    column :status do |s|
      if s.status
        "Active"
      else
        "Inactive"
      end
    end
    column "Affiliate Admin",:is_affiliate_admin do |a|
      if a.is_affiliate_admin
        "Yes"
      else
        "No"
      end
    end
    # column "Orders" do |expert|
      # link_to "View", edit_admin_expert_path(expert)
    # end    
    default_actions                  
  end                                 

  filter :username
  filter :products
  filter :status                  

  csv :separator => ';' do
     column :username
     column :email
     column :created_at
  end                          
  
  form do |f| 
    #f.inputs :username
    f.inputs "Admin" do
        f.input :email, :label => "Username"
        f.input :crypted_password
    end
    #f.inputs :email, :label => "ADMIN Username"
    
    f.inputs :products
    f.inputs "Status" do
        f.input :status, :label => "Active"
    end             
    #f.inputs :status 
    f.inputs "Make Affiliate Admin" do
        f.input :is_affiliate_admin, :label => "Yes"
    end
     if f.object.new_record?
       f.inputs "Select Affiliate" do
         f.input :user_id, :label =>"Affiliates", :as => :select, :collection => User.where(:is_affiliate_admin => true ).map { |u| [u.email, u.id] }, :prompt => "Select Affiliate Admin"
       end
     else
        f.inputs "Select Affiliate" do
          f.input :user_id, :label =>"Affiliates", :as => :select, :collection => User.where(['id != ? AND is_affiliate_admin = ?', params[:id], true] ).map { |u| [u.email, u.id] }, :prompt => "Select Affiliate Admin"
        end
     end
     
    f.actions                         
  end 
  
  show do
    div :class => 'panel' do
      h3 'Affiliate'
      div :class => 'panel_contents' do
        div :class => 'attributes_table users' do
          table do
            # tr do
              # th { 'Username' }
              # td { user.username }
            # end
            tr do
              th { 'Username' }
              td { user.email }
            end
            tr do
              th { 'Password' }
              td { user.crypted_password }
            end
            tr do
              th { 'Products' }
              td { user.products.map{ |p| p.name }.join(',') }
              
            end
            tr do
              th { 'Affiliate Admin' }
              td {
                if user.is_affiliate_admin
                  "Yes"
                else
                  "No"
                end
                  #user.is_affiliate_admin 
                }              
            end
            if !user.is_affiliate_admin
              tr do
                th { 'Affilate Admin Name' }
                td { User.find(user.user_id).email if !user.user_id.nil?  }              
              end
            end            
            tr do
              th { 'Login as' }
              td { link_to user.email, "/admin_as_affiliate/#{user.id}/affiliate" }
            end
      
            
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end #
  
  
  
  controller do
    def update
      logger.info "######  #{params[:user][:user_id]} ###########{params[:id]}########"
      logger.info "######  #{params[:user][:is_affiliate_admin].eql?("1")} ########### inside update  ########"
            
      if !params[:user][:is_affiliate_admin].eql?("1")
          params[:user][:product_ids] = []
          params[:user][:user_id] = nil           
      end
      # my custom code
      logger.info "######  #{params[:user][:user_id]} ###########{params[:id]}########"
      
      @user = User.find(params[:id])
      @user.is_affiliate_admin = params[:user][:is_affiliate_admin]
      @user.user_id = params[:user][:user_id]
      @user.product_ids = params[:user][:product_ids]
      
      logger.info "######  #{params[:user][:user_id]} ###########{params[:id]}########"
      logger.info "######  #{params[:user][:is_affiliate_admin]} ###########{params[:id]}########"
      logger.info "######  #{params[:user][:product_ids]} ###########{params[:id]}########"
      logger.info "######  #{params[:user][:id]} ###########{params[:id]}########"
      
      if @user.save         
        if params[:user][:is_affiliate_admin].eql?("1")               
          redirect_to("/admin/affiliates/#{params[:id]}")         
          return
        else        
          redirect_to admin_users_url
          return  
        end        
      end      
    end
    
    def create
      # my custom code
      @email = params[:user][:email]
      @username = params[:user][:username]
      @password  = params[:user][:crypted_password]
      
      @check_name = User.find_all_by_username(params[:user][:username])
      @check_email = User.find_all_by_email(params[:user][:email])
      
      if username_match(@username) and email_match(@email) and password_match(@password) and @check_name.count < 1 and @check_email.count < 1         
        logger.info "######  #{params[:user][:email]} ###########{params[:id]}########"        
        create! do           
         if !params[:user][:is_affiliate_admin]
             #logger.info "#### unique email created ##  #{params[:user][:email]} ###########{params[:id]}########"
             redirect_to("/admin/affiliate/#{params[:user][:username]}")        
             return                                  
          end   
        end
      else
          create!
      end      
    end
    
    def email_match(email)
       email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
           
       if  !email.nil? and (email =~ email_regex)  
         logger.info "###### email true  ########"
         true
       else
         logger.info "###### email false  ########"
         false         
       end
    end
    
    def password_match(password)
       logger.info "###### password  ######## #{password}  #{password.to_s.length} "
       
       if !password.nil? and (password.to_s.length >= 6)
         logger.info "###### password true  ########"
         true
       else
         logger.info "###### password false  ########"
         false
       end
    end
    
    def username_match(username)      
      
       if !username.nil? and !(username.length < 6)  
         logger.info "###### username true  ########"
         true
       else
         logger.info "###### username false  ########"
         false
       end
    end
     
    
  end
  
  
end
