ActiveAdmin.register ShippingDetail do
  index do                            
    column :first_name                     
    column :last_name    
    column :product
    column :email
    column :phone
    column :payment_method  
    column :user
    
    default_actions                   
  end                                 
  filter :first_name
  filter :last_name
  filter :user
  filter :city
  filter :email  
    
   form do |f|

    f.inputs :first_name
    f.inputs :last_name
    f.inputs :address1
    f.inputs :address2
    f.inputs :city
    f.inputs :state
    f.inputs :zip
    f.inputs :email
    f.inputs :user
    f.inputs :payment_method
    f.inputs :paypal_email
    f.inputs :product    
     
    f.actions                         
  end  
end
