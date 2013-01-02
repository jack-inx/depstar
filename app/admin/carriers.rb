ActiveAdmin.register Carrier do

  index do                            
    column :name
    #column :series_lists
    column "Products" do |p|
      (p.series_lists.map{ |s| s.name }).join(',')
    end
    column :image do |carrier|
      image_tag(carrier.image.url(:small), :alt => "Image not exists")
    end                     

    default_actions                   
  end                                 
  filter :name
  
  show do
    div :class => 'panel' do
      h3 'Manufacturer Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table carrier' do
          table do
            tr do
              th { 'Name' }
              td { carrier.name }
            end
            tr do
              th { 'Product' }
              td { (carrier.series_lists.collect{ |p| p.name }).join(',') }
            end
            tr do
              th { 'Image' }
              td { image_tag(carrier.image.url(:small), :alt => "Image not exists") }
            end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show

  form do |f|

    f.inputs :name
    f.inputs :series_lists
    f.inputs :image, :as => :file, input_html: { multiple: true}    
    f.buttons                         
  end #form
end
