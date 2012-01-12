xml.instruct!
xml.response do
  xml.offer @question_response.quote
  xml.shipping_options do
    xml.free_shipping_label 'yes'
    xml.box_shipping_available 'yes'
  end

  xml.checkout_url 'http://' + request.env["HTTP_HOST"] + product_path(:id => @question_response.product_id, :question_response => {:product_id => @question_response.product_id, :question_1 => @question_response.question_1, :question_2 => @question_response.question_2, :question_3 => @question_response.question_3, :question_4 => @question_response.question_4})
end