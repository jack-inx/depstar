xml.instruct!
xml.response do
  xml.total @shipping_details_total
  xml.returned @shipping_details.count
  xml.orders do
      @shipping_details.each do |shipping_detail|
        xml.order do
          xml.uuid shipping_detail.uuid
          xml.num_orders shipping_detail.orders_count
          xml.recent_order_date shipping_detail.created_at.in_time_zone("Eastern Time (US & Canada)").strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end
end