xml.instruct!
xml.response do
  xml.offer @question_response.quote unless @question_response.quote.nil?
  xml.shipping_options do
    xml.free_shipping_label 'yes'
    xml.box_shipping_available 'yes'
  end

  xml.checkout_url @product_link
end