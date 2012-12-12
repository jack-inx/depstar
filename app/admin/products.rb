ActiveAdmin.register Product do
  index do                            
    column :name                     
    column :category
    column :manufacturer
    column :series_list
    column "Carrier*",:carrier
    column "Price (Flawless)",:price
    column "Price (Used)",:used_price
    column "Price (Broken)",:broken_price
    
    column :photo do |product|
      image_tag(product.photo.url(:thumb), :alt => "Image not exists")
    end
    
    default_actions                   
  end                                 
  filter :name
    show do
    div :class => 'panel' do
      h3 'Product Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table product' do
          table do
            tr do
              th { 'Name' }
              td { product.name.nil? ? "" : product.name  }
            end
            tr do
              th { 'Description' }
              td { product.description }
            end            
            tr do
              th { 'category' }
              td { product.category.name }
            end          
            tr do
              th { 'manufacturer' }
              td { product.manufacturer.name }
            end          
            tr do
              th { 'carrier' }
              td { product.carrier.name }
            end          
            tr do
              th { 'price (flawless)' }
              td { product.price }
            end 
             tr do
              th { 'price (used)' }
              td { product.used_price }
            end 
             tr do
              th { 'price (broken)' }
              td { product.broken_price }
            end  
             tr do
              th { 'Series List' }
              td { product.series_list.name }
            end          
            tr do
              th { 'Image' }
              td { image_tag(product.photo.url(:thumb), :alt => "Image not exists") }
            end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show


  form do |f|
    f.inputs :name
    f.inputs :description
    f.inputs :category
    f.inputs :manufacturer
    f.inputs :series_list
    f.inputs :carrier   
    
     f.inputs "Price ($)" do
        f.input :price, :label => "Flawless"
        f.input :used_price, :label => "Used"
        f.input :broken_price, :label => "Broken"
      end
      
    f.inputs :photo, :as => :file, input_html: { multiple: true}

    f.buttons                         
  end #form
end
