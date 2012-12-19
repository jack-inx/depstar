module OrdersHelper
  def get_product_price(products, order_id)
    @array = []   
    products.each do |product|       
      @array.push(OrderProductPriceType.where(:order_id => order_id, 
      :product_id => product.id))       
    end    
    return @array    
  end
  def get_category(user_id,type)
    @category = Array.new
    @product = user_id.products
    if type =="category"
      @product.each do |prdct|
        @category << prdct.category.name
      end
    end
    if type =="series_list"
      @product.each do |prdct|
        @category << prdct.series_list.name
      end
    end
    if type =="carrier"
      @product.each do |prdct|
        @category << prdct.carrier.name
      end
    end
    if type =="manufacturer"
      @product.each do |prdct|
        @category << prdct.manufacturer.name
      end
    end
    return @category.uniq 
  end
  def update_versions_div(name)
    @name = Array.new
    
    return @name << hello
  end
end

