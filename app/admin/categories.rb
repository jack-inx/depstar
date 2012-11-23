ActiveAdmin.register Category do
  index do                            
    column :name                     
    column :is_popular       

    default_actions                   
  end                                 
  filter :name

end
