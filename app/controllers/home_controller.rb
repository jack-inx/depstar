class HomeController < ApplicationController  
  autocomplete :product, :name, :full => true
  
  def index     
    @categories = Category.find_all_by_is_popular(true)
        
    #@products = Product.find_all_by_is_popular(true)
  end
  
end
