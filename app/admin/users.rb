ActiveAdmin.register User do  
  menu :priority => 1,:label => "Affiliates"  
  
  index do                            
    column :username                     
    column :email
    column :crypted_password
    column :created_at     
    column :status
    # column "Orders" do |expert|
      # link_to "View", edit_admin_expert_path(expert)
    # end    
    default_actions                  
  end                                 

  filter :username
  filter :email     
  filter :status                  

  csv :separator => ';' do
     column :username
     column :email
     column :created_at
  end                          
  
  form do |f| 
    f.inputs :username
    f.inputs :email
    f.inputs :crypted_password
    f.inputs :products             
    f.inputs :status    
    f.actions                         
  end 
  
  show do
    div :class => 'panel' do
      h3 'Affiliate'
      div :class => 'panel_contents' do
        div :class => 'attributes_table users' do
          table do
            tr do
              th { 'Username' }
              td { user.username }
            end
            tr do
              th { 'Email' }
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
              th { 'Login as' }
              td { link_to user.username, "/admin_as_affiliate/#{user.id}/affiliate" }
            end
      
            
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end #
  
  controller do
    def create
      # my custom code
      create!
      redirect_to root_url
    end
  end
  
  controller do
    def update
      # my custom code
      update! do 
        logger.info "######  #{params[:user][:email]} ###########{params[:id]}########"
        redirect_to("/admin/affiliates/#{params[:id]}")
        
        return  
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
       
             logger.info "#### unique email created ##  #{params[:user][:email]} ###########{params[:id]}########"
             redirect_to("/admin/affiliate/#{params[:user][:username]}")        
             return                     
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
