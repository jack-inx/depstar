Trunk::Application.routes.draw do  #match 'get_quote' => 'price_quotes#get_quote'
  
  resources :question_response
  resources :categories
  resources :shipping_details
  match 'shipping_details/confirm', :controller => :shipping_details, :action => :confirm
  
  resources :products
  resources :manufacturers
  match 'search', :controller => "products", :action => "search"
  match 'get_quote'     => 'products#get_quote'
  match 'accept_quote'  => 'products#accept_quote'
  
  match 'question_responses' => 'products#get_quote'
  
  match 'admin' => 'admin#index'
  match 'home' => 'home#index'
  match 'dev' => 'home#index'
  match 'root' => 'home#index'

  get "home/show"
  root :to => "home#index"  
  get 'home/autocomplete_product_name'
  
  resources :users, :user_sessions
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  match 'corporate' => 'corporate#index'
  match 'go_green' => 'go_green#index'
  match 'get_paid' => 'get_paid#index'
  
  match 'privacy_policy' => 'privacy_policy#index'
end
