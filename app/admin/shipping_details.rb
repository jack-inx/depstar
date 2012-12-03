ActiveAdmin.register ShippingDetail do
  index do                            
    column :first_name                     
    column :last_name
    column :city
    column :email
    column :phone
    column :paypal_email
         
    
    
    default_actions                   
  end                                 
  filter :first_name
  filter :last_name
  filter :city
  filter :email
  filter :phone
end
