xml.instruct!
xml.response do
  xml.total @shipping_details_total
  xml.returned @shipping_details.count
  xml.orders do
      @shipping_details.each do |shipping_detail|
        xml.order do
          xml.uuid shipping_detail.uuid
          xml.num_orders shipping_detail.orders_count
          xml.num_orders shipping_detail.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end
end