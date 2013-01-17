ActiveAdmin.register SeriesList,:as => "Product" do
 index do                            
    column :name
    #column :manufacturer 
    column :category                       
    #column "Carriers" do |manufacture|
      #(manufacture.carriers.map{ |p| p.name }).join(',')
    #end
    default_actions                   
  end                                 
  filter :name
  
  form do |f|

    f.inputs :name    
    #f.inputs :manufacturer
    f.inputs :category
    #f.inputs :carriers
    f.inputs :image, :as => :file, input_html: { multiple: true}
     
    f.buttons                         
  end  
  
  show do
    div :class => 'panel' do
      h3 'Series Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table product' do
          table do
            tr do
              th { 'Name' }
              td { product.name }
            end
            # tr do
              # th { 'Manufacturer' }
              # td { product.manufacturer.name }
            # end
            tr do
              th { 'Category' }
              td { product.category.name }
            end
           # tr do
              # th { 'Carriers' }
              # td { (product.carriers.collect{ |p| p.name }).join(',') }
            # end
	    tr do
              th { 'Image' }
              td { image_tag(product.image.url(:small), :alt => "Image not exists") }
            end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end #
end
