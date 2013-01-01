ActiveAdmin.register Product, :as => "Catologue" do
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
      image_tag(product.photo.url(:small), :alt => "Image not exists")
    end
    
    default_actions                   
  end                                 
  filter :name
    show do
    div :class => 'panel' do
      h3 'Product Details'
      div :class => 'panel_contents' do
        div :class => 'attributes_table catologue' do
          table do
            tr do
              th { 'Name' }
              td {  catologue.name.nil? ? "" :  catologue.name  }
            end
            tr do
              th { 'Description' }
              td {  catologue.description }
            end            
            tr do
              th { 'category' }
              td {  catologue.category.name }
            end          
            tr do
              th { 'manufacturer' }
              td {  catologue.manufacturer.name }
            end          
            tr do
              th { 'carrier' }
              td {  catologue.carrier.name }
            end          
            tr do
              th { 'price (flawless)' }
              td {  catologue.price }
            end 
             tr do
              th { 'price (used)' }
              td {  catologue.used_price }
            end 
             tr do
              th { 'price (broken)' }
              td { catologue.broken_price }
            end  
             tr do
              th { 'Series List' }
              td {  catologue.series_list.name }
            end          
            tr do
              th { 'Image' }
              td { image_tag( catologue.photo.url(:small), :alt => "Image not exists") }
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
