ActiveAdmin.register ShippingDetail, :as => "Shipping Requests" do
  #menu :label => "Shipping Requests"
  index do       
    menu :label => "Shipping Requests"
                
    column :first_name
    column :last_name
    column :product
    column :email
#    column :status_code
    column :referer
    column :offer
    column :final_offer
    column "Referrer Status" do |status|
      (status.devices.map{|s| ShippingDetail::ShippingStatus.at(s.status_code)[0]}).join(',')
    end
    column "Depstar Status" do |s|
      ShippingDetail::ShippingStatus.at(s.status_code)[0]
    end
    #column :phone
    column :payment_method  
    column "Date",:created_at

    default_actions                   
  end   
   
  csv :separator => ';' do
     column("FirstName")  { |post| post.first_name }
     column("LastName") { |post| post.last_name }
     column("Product")  { |post| post.product.name.gsub(' ','-') if !post.product.nil?  }
     column("Email")  { |post| post.email }
     column("Referer")  { |post| post.referer }
     column("Offer")  { |post| post.offer }
     column("FinalOffer")  { |post| post.final_offer }
     column "ReferrerStatus" do |status|
        (status.devices.map{|s| ShippingDetail::ShippingStatus.at(s.status_code)[0]}).join(',')
     end
     column "DepstarStatus" do |s|
        ShippingDetail::ShippingStatus.at(s.status_code)[0]
     end
     column("PaymentMethod")  { |post| post.payment_method.name if !post.payment_method.nil? }  
     column("Date")  { |post| post.created_at.strftime("%d/%m/%y") }
  end 
                                
  filter :first_name
  filter :last_name
  filter :user
  filter :city
  filter :email  
    
  form do |f|
   f.inputs do 
     f.input :payment_method, :as => :radio
   end

    f.has_many :devices do |dev|
      dev.input :name, :input_html => {:disabled => true }
      dev.input :status_code, :as => :select, :collection =>ShippingDetail::ShippingStatus
      dev.input :serial, :as => :string, :input_html => {:size => "12"}
      dev.input :offer
      dev.input :final_offer
      dev.input :notes, :as => :text
      #dev.buttons :submit, :input_html => {:hidden => true}
    end
    
    f.inputs :email
    f.inputs :first_name
    f.inputs :last_name    
    f.inputs :phone  
    f.inputs :address1
    f.inputs :address2   
    f.inputs :city
    f.inputs :state
    f.inputs :zip      
    f.inputs :paypal_email
    f.inputs :uuid
    f.inputs "Shipping" do
      f.input :status_code, :as => :select, :collection =>ShippingDetail::ShippingStatus   
    end
    f.inputs :serial
    f.inputs :offer
    f.inputs :final_offer        
    f.inputs :referer        
    #f.inputs :notes, :as => :textarea
      
    f.actions                         
  end  
  
  show do
    div :class => 'panel' do
      h3 'Shipping Requests'
      div :class => 'panel_contents' do
        div :class => 'attributes_table shipping_request' do
          table do
            tr do
              th { 'First Name' }
              td { shipping_requests.first_name }
            end
            tr do
              th { 'Last Name' }
              td { shipping_requests.last_name }
            end 
             tr do
              th { 'Email' }
              td { shipping_requests.email }
            end      
           
            
             tr do
              th { 'Phone' }
              td { shipping_requests.phone }
            end 
            
             tr do
              th { 'Address 1' }
              td { shipping_requests.address1 }
            end 
             tr do
              th { 'Address 2' }
              td { shipping_requests.address2 }
            end          
            
             tr do
              th { 'City' }
              td { shipping_requests.city }
            end 
            
            tr do
              th { 'State' }
              td { shipping_requests.state }
            end
            tr do
              th { 'Zip' }
              td { shipping_requests.zip }
            end
            
             tr do
              th { 'UUid' }
              td { shipping_requests.uuid }
            end 
             tr do
              th { 'Serial' }
              td { shipping_requests.serial }
            end 
            tr do
              th { 'Referrer' }
              td { shipping_requests.referer }
            end 
            tr do
              th { 'Offer' }
              td { shipping_requests.offer }
            end 
            tr do
              th { 'Final Offer' }
              td { shipping_requests.final_offer }
            end              
            tr do
              th { 'Payment Method' }
              td { shipping_requests.payment_method.name }
            end
            
            tr do
              th { 'Paypal Email' }
              td { shipping_requests.paypal_email }
            end
             tr do
              th { 'Status' }
              td { ShippingDetail::ShippingStatus[shipping_requests.status_code].first }
            end             
                      
            tr do
              th { 'Notes' }
              td { shipping_requests.notes }
            end            
         
         #    if !shipping_requests.devices.map(&:name).first.nil?
         #      tr do
         #        th { 'Device name' }
         #        td { shipping_requests.devices.map(&:name).join(' ')}              
         #      end   
         #    end
         #    if !shipping_requests.devices.map(&:status_code).first.nil?            
         #      tr do
         #        th { 'Status code' }
         #        td { shipping_requests.devices.map(&:status_code).join(' ')}              
         #      end            
         #    end
         #   if !shipping_requests.devices.map(&:serial).first.nil?
         #      tr do
         #        th { 'Series' }
         #        td { shipping_requests.devices.map(&:serial).join(' ') }              
         #      end            
         #    end
         #   if !shipping_requests.devices.map(&:offer).first.nil?
         #      tr do
         #        th { 'Offer' }
         #        td { shipping_requests.devices.map(&:offer).join(' ') }              
         #      end            
         #    end
         #   if !shipping_requests.devices.map(&:final_offer).first.nil?
         #      tr do
         #        th { 'Final Offer' }
         #        td { shipping_requests.devices.map(&:final_offer).join(' ') }              
         #      end            
         #    end
        
           
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show
end
