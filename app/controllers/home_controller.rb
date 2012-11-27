require 'open-uri'
require 'hpricot'

class HomeController < ApplicationController  
  autocomplete :product, :name, :full => true
  
  def index     
    @categories = Category.all
    @blogs = Blog.order("created_at").limit(4)    
    #@products = Product.find_all_by_is_popular(true)

    doc = open("http://depstar.com/blog/") { |f|
    Hpricot(f) 
}
 (doc/".description-box.add").inner_html
 @title=[]
 @posted_by=[]
 @image_url=[]
 (doc/".description-box.add/h2").each do |f|
 	@title << f
 end
 (doc/".description-box.add/.date-box").each do |posted|
 	@posted_by << posted.html
 end

  (doc/".description-box.add/.info-box/img@src").each do |f|

  	@image_url << f.attributes['src']
  end

 end
  
end
