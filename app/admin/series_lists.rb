ActiveAdmin.register SeriesList do
 index do                            
    column :name
    column :category                        

    default_actions                   
  end                                 
  filter :name
  
  form do |f|

    f.inputs :name    
    f.inputs :category
     
    f.buttons                         
  end  
  
  show do
    div :class => 'panel' do
      h3 'Series Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table series_lists' do
          table do
            tr do
              th { 'Name' }
              td { series_list.name }
            end
            tr do
              th { 'Category' }
              td { series_list.category.name }
            end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end #
end
