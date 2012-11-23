ActiveAdmin.register Product do
  index do                            
    column :name                     
    column :image_file_name       
    column :price
    column :manufacturer
    default_actions                   
  end                                 
  filter :name

end
