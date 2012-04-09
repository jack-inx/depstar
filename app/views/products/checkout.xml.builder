xml.instruct!
xml.response do
  xml.shipping_options do
    xml.shipping_option do
      xml.option_id 1
      xml.cost_to_customer '0'
      xml.shipping_type 1, :name => 'printed shipping label'
    end
    xml.shipping_option do
      xml.option_id 2
      xml.cost_to_customer 0
      xml.shipping_type 1, :name => 'box sent in mail'
    end
  end
  xml.payment_options do
    xml.payment_option do
      xml.option_id 3
      xml.payment_method_name 'Paypal'
      xml.payment_type 1, :name => 'paypal'
    end
    xml.payment_option do
      xml.option_id 4
      xml.payment_method_name 'Check'
      xml.payment_type 2, :name => 'check'
    end
  end
end