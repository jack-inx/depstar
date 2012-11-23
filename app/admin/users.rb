ActiveAdmin.register User do
  menu :priority => 1  
  index do                            
    column :username                     
    column :email
    column :login_count
    column :current_login_ip    
    column :last_login_ip
    column :created_at           

    default_actions                   
  end                                 
  filter :username
  filter :email                       

                                  

end
