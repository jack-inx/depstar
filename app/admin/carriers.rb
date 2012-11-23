ActiveAdmin.register Carrier do
    
  index do                            
    column :name                     
    column :image_file_name       

    default_actions                   
  end                                 
  filter :name

  
end
