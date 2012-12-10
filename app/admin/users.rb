ActiveAdmin.register User do
  menu :priority => 1  
  index do                            
    column :username                     
    column :email
    column :crypted_password
    column :created_at     
    column :status      
    
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
    f.inputs :status
    f.actions                         
  end 
  
end
