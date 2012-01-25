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
          xml.date_submited shipping_detail.created_at
          xml.email shipping_detail.email
          xml.id shipping_detail.id
          xml.initial_total_offer shipping_detail.question_response.quote
          xml.final_total_offer shipping_detail.final_offer_or_default
          xml.offers do
            xml.offer do
              xml.offer_id shipping_detail.id
              xml.category shipping_detail.product.category.usell_category_code
              xml.initial_offer shipping_detail.question_response.quote
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