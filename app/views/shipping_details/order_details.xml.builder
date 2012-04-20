xml.instruct!
xml.response do
  if @shipping_details.count == 0
    xml.error 'UUID Not Found'
  else
    xml.uuid @uuid
    xml.orders do
      @shipping_details.each do |shipping_detail|
        xml.order do
          xml.name shipping_detail.first_name + ' ' + shipping_detail.last_name
          xml.date_updated shipping_detail.updated_at
          xml.date_submitted shipping_detail.created_at
          xml.email shipping_detail.email
          xml.id shipping_detail.id
          if shipping_detail.devices.count == 0
            xml.initial_total_offer shipping_detail.offer_or_default
            xml.final_total_offer shipping_detail.final_offer_or_default
          else
            xml.initial_total_offer shipping_detail.initial_total_offer
            xml.final_total_offer shipping_detail.final_total_offer
          end
          
          xml.offers do
            shipping_detail.devices.each do |device|
              xml.offer do
                xml.offer_id device.id
                xml.category device.product.category.usell_category_code unless shipping_detail.product.nil?
                xml.initial_offer device.offer_or_default
                xml.final_offer device.final_offer_or_default
                xml.initial_product_id device.product.id
                xml.initial_name device.product.name
                xml.final_product_id device.product.id
                xml.final_name device.product.name
                xml.status device.status
              end
            end
            
            if shipping_detail.devices.count == 0
              xml.offer do
                xml.offer_id shipping_detail.id
                xml.category shipping_detail.product.category.usell_category_code unless shipping_detail.product.nil?
                xml.initial_offer shipping_detail.offer_or_default
                xml.final_offer shipping_detail.final_offer_or_default
                xml.initial_product_id shipping_detail.product.id
                xml.initial_name shipping_detail.product.name
                xml.final_product_id shipping_detail.product.id
                xml.final_name shipping_detail.product.name
                xml.status shipping_detail.status
              end
            end
            
          end
        end
      end
    end
  end
end