ActiveAdmin.register Manufacturer do
  index do                            
    column :name                     
    column :photo_file_name       

    default_actions                   
  end                                 
  filter :name

   form do |f|                         
    f.inputs "Manufacturers" do       
      f.text_field :name
      f.select :carrier_id, :collection => Carrier.all.map(&:name)
    end                               
    f.buttons                         
  end                                 
 

end
