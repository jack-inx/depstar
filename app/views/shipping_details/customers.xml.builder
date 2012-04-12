xml.instruct!
xml.response do
  unless @error.nil?
    xml.response @error
  else
    xml.customer do
      xml.name @shipping_detail.full_name
      xml.email @shipping_detail.email
      xml.phone @shipping_detail.phone
      xml.paypal_email @shipping_detail.paypal_email
      xml.shipping_address do
        xml.address1 @shipping_detail.address1
        xml.address2 @shipping_detail.address2
        xml.city @shipping_detail.city
        xml.state @shipping_detail.state
        xml.zip @shipping_detail.zip
      end
      xml.billing_address do
        xml.address1 @shipping_detail.address1
        xml.address2 @shipping_detail.address2
        xml.city @shipping_detail.city
        xml.state @shipping_detail.state
        xml.zip @shipping_detail.zip
      end
    end
  end
end