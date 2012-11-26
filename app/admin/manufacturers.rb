ActiveAdmin.register Manufacturer do
  index do                            
    column :name                     
  
    default_actions                   
  end                                 
  filter :name

  show do |event|
    attributes_table do
      row :name
    
    end
    active_admin_comments
  end

   form do |f|

    f.inputs :name

    f.inputs "Carriers" do
            f.input :id, :label => "Select Carriers",  
                :as => :select, 
                :multiple => true, 
                :collection => Carrier.all,
                :selected => "Select Carriers"
    end
    #f.select :carrier_ids, :collection => Carrier.all.map(&:name)
    
    f.buttons                         
  end                                 
 

end
