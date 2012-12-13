module OrdersHelper
  def get_product_price(products, order_id)
    @array = []   
    products.each do |product|       
      @array.push(OrderProductPriceType.where(:order_id => order_id, 
      :product_id => product.id))       
    end    
    return @array    
  end
end
