ActiveAdmin.register Category do
  index do                            
    column :name                     
    column "Manufacturer" do |category|
      (category.manufacturers.map{ |p| p.name }).join(',')
    end
    default_actions                   
  end                                 
  filter :name

  show do
    div :class => 'panel' do
      h3 'Category Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table category' do
          table do
            tr do
              th { 'Name' }
              td { category.name }
            end
            tr do
              th { 'Carrier' }
              td { (category.manufacturers.map{ |p| p.name }).join(',') }
            end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show

   form do |f|

    f.inputs :name
    f.inputs :manufacturers
    f.inputs :image, :as => :file, input_html: { multiple: true}
    
    f.buttons                         
  end                                 

end
