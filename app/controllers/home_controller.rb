require 'open-uri'
require 'hpricot'

class HomeController < ApplicationController  
  autocomplete :product, :name, :full => true
  
  def index     
    @categories = Category.all
    @shippings = ShippingDetail.order("created_at ASC").limit(3)
    @blogs = Blog.order("created_at").limit(4)    

    doc = open("http://depstar.com/blog/") { |f|
    Hpricot(f) 
}
 (doc/".description-box").inner_html
 @title=[]
 @posted_by=[]
 @image_url=[]
 (doc/".description-box/h2/a").each do |f|
 	@title << f
 end
 (doc/".description-box/.date-box").each do |posted|
 	@posted_by << posted.html
 end

  (doc/".description-box/.info-box/img@src").each do |f|

  	@image_url << f.attributes['src']
  end

 end
  
end
