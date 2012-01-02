xml.instruct!
xml.response do
  xml.total @products.count
  xml.returned @products.count
  xml.products do
    @products.each do |product|
      xml.product do
        xml.id product.id
        xml.manufacturer (product.manufacturer.nil? ? nil : product.manufacturer.name)
        xml.name product.name
        xml.category ((product.category.nil? || product.category.usell_category_code.nil?) ? 0 : product.category.usell_category_code)
        xml.url polymorphic_url(product)
        xml.deeplink polymorphic_url(product)
        xml.thumbnail_URL product.photo.url(:original)
        xml.image_URL product.photo.url(:small)
        xml.price_poor product.price_poor
        xml.price_good product.price_good
        xml.price_excellent product.price_excellent
      end
    end
  end
end