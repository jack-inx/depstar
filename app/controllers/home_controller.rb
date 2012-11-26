class HomeController < ApplicationController  
  autocomplete :product, :name, :full => true
  
  def index     
    @categories = Category.find_all
    @blogs = Blog.order("created_at").limit(4)    
    #@products = Product.find_all_by_is_popular(true)
  end
  
end
