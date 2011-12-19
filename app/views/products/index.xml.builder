xml.instruct!
xml.products do
  @products.each do |product|
    xml.product do
      #debugger
      xml.id product.id
      xml.manufacturer (product.manufacturer.nil? ? nil : product.manufacturer.name)
      xml.name product.name
      #xml.description product.description
      xml.deeplink polymorphic_url(product)
      xml.thumbnail_URL product.photo.url(:original)
      xml.image_URL product.photo.url(:small)
      xml.price_poor product.price_poor
      xml.price_good product.price_good
      xml.price_excellent product.price_excellent     
      # xml.comments do
      #         post.comments.each do |comment|
      #           xml.comment do
      #             xml.body comment.body
      #           end
      #         end
      #end
    end
  end
end