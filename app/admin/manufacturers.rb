ActiveAdmin.register Manufacturer do
  index do                            
    column :name                     
    column "carrier" do |manufacturer|
      (manufacturer.carriers.map{ |p| p.name }).join(',')
    end
    column :photo do |manufacturer|
      image_tag(manufacturer.photo.url(:small), :alt => "Image not exists")
    end                      

    default_actions                   
  end                                 
  filter :name

  show do
    div :class => 'panel' do
      h3 'Manufacturer Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table manufacturer' do
          table do
            tr do
              th { 'Name' }
              td { manufacturer.name }
            end
            tr do
              th { 'Carrier' }
              td { (manufacturer.carriers.map{ |p| p.name }).join(',') }
            end
            tr do
              th { 'Image' }
              td { image_tag(manufacturer.photo.url(:small), :alt => "Image not exists") }
            end            
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show

   form do |f|

    f.inputs :name
    f.inputs :carriers
    f.inputs :photo, :as => :file
    f.buttons                         
  end                                 
 

end
