class HomeController < ApplicationController
  
  #before_filter :authorize
  
  def index
        @categories = Category.find_all_by_is_popular(true, :limit => 5)
        
        @products = Product.find_all_by_is_popular(true, :limit => 4)
  end
  
end
