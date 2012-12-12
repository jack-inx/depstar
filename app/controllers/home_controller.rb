require 'open-uri'
require 'hpricot'

class HomeController < ApplicationController
  
  autocomplete :product, :name, :full => true
  
  def index
    @categories = Category.order("name DESC")
    logger.info(" #{@categories.inspect}   ")
    @index = 0
    @categories.each do |category|             
      if category.name.eql?("iPhones") or category.name.eql?("iPhone")
        @temp = @categories[0]
        @categories[0] = @categories[@index]
        @categories[@index] = @temp  
      end
      @index += 1    
    end
       
    @shippings = ShippingDetail.order("created_at DESC").limit(3)
    @blogs = Blog.order("created_at").limit(4)

    doc = open("http://depstar.com/blog/") { |f| Hpricot(f)  }
    
    @title=[]
    @posted_by=[]
    @image_url=[]
    
    doc = open("http://depstar.com/blog/") { |f| Hpricot(f)  }
    
    (doc/".description-box").each do |box|      
        @title << (box/"h2").html
        @posted_by << (box/".date-box").html
        if !(box/".info-box/img").blank?
          @image_url << (box/".info-box/img").first.attributes['src']
        else
          @image_url << ""
        end
    end
  end

end
