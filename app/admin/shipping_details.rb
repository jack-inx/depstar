ActiveAdmin.register ShippingDetail do
  index do                            
    column :first_name                     
    column :last_name
    column :city
    column :email
    column :phone
    column :paypal_email
    column :image_file_name       
    column :price
    column :manufacturer
    default_actions                   
  end                                 
  filter :first_name
  filter :last_name
  
end
