ActiveAdmin.register Order do
    filter :first_name
    
    index do                            
    column :first_name                     
    column :last_name
    column :email
    column :address   
    column "Affiliates" do |product|
      product.user.username
    end
      
    
    default_actions                  
  end 
end
