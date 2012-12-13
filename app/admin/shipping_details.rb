ActiveAdmin.register ShippingDetail do
  index do                            
    column :first_name                     
    column :last_name    
    column :product
    column :email
    column :phone
    column :payment_method  
   
    
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
    f.inputs :payment_method
    f.inputs :paypal_email
  
     
    f.actions                         
  end  
  
  show do
    div :class => 'panel' do
      h3 'Shipping Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table shipping_detail' do
          table do
            tr do
              th { 'First Name' }
              td { shipping_detail.first_name }
            end
            tr do
              th { 'Last Name' }
              td { shipping_detail.last_name }
            end            
                    
                     
            tr do
              th { 'Email' }
              td { shipping_detail.email }
            end          
            tr do
              th { 'Phone' }
              td { shipping_detail.phone }
            end 
             # tr do
              # th { 'price (used)' }
              # td { product.used_price }
            # end 
             # tr do
              # th { 'price (broken)' }
              # td { product.broken_price }
            # end  
             # tr do
              # th { 'Series List' }
              # td { product.series_list.name }
            # end          
            # tr do
              # th { 'Image' }
              # td { image_tag(product.photo.url(:thumb), :alt => "Image not exists") }
            # end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show
end
