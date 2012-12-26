ActiveAdmin.register ShippingDetail do
  menu :label => "Shipping Requests"
  index do                            
    column :first_name
    column :product
    column :email
    column :status_code
    column :referer
    column :offer
    column :final_offer
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
    f.inputs :email
    f.inputs :phone  
    f.inputs :address1
    f.inputs :address2   
    f.inputs :city
    f.inputs :state
    f.inputs :zip      
    f.inputs :uuid
    f.inputs :serial
    f.inputs :referer
    f.inputs :offer
    f.inputs :final_offer        
    f.inputs :payment_method
    f.inputs :paypal_email
    
    f.inputs "Shipping" do
      f.input :status_code, :as => :select, :collection =>ShippingDetail::ShippingStatus   
    end
    
    f.inputs :notes, :as => :textarea
      
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
            
             tr do
              th { 'Address 1' }
              td { shipping_detail.address1 }
            end 
             tr do
              th { 'Address 2' }
              td { shipping_detail.address2 }
            end          
            
             tr do
              th { 'City' }
              td { shipping_detail.city }
            end 
            
            tr do
              th { 'State' }
              td { shipping_detail.state }
            end
            tr do
              th { 'Zip' }
              td { shipping_detail.zip }
            end
            
             tr do
              th { 'UUid' }
              td { shipping_detail.uuid }
            end 
             tr do
              th { 'Serial' }
              td { shipping_detail.serial }
            end 
            tr do
              th { 'Referrer' }
              td { shipping_detail.referer }
            end 
            tr do
              th { 'Offer' }
              td { shipping_detail.offer }
            end 
            tr do
              th { 'Final Offer' }
              td { shipping_detail.final_offer }
            end              
            tr do
              th { 'Payment Method' }
              td { shipping_detail.payment_method.name }
            end
            
            tr do
              th { 'Paypal Email' }
              td { shipping_detail.paypal_email }
            end
             tr do
              th { 'Status' }
              td { ShippingDetail::ShippingStatus[shipping_detail.status_code].first }
            end             
                      
            tr do
              th { 'Notes' }
              td { shipping_detail.notes }
            end            
            
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show
end
