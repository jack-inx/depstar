xml.instruct!
xml.response do
    xml.uuid @uuid
    xml.status @status
    xml.errors @error unless @error.nil? 
    xml.customer_id @customer_id
    xml.order_id @order_id
end