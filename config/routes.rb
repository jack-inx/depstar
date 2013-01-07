Trunk::Application.routes.draw do

  resources :profiles
  
  resources :orders

  #resources :blogs

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match 'search' => 'categories#search_filter'  
  match 'search_result' => 'categories#get_search_result' 
  match 'categories/show/' => 'categories#show' # For the homepage form
  match "/admin_as_affiliate/:id/affiliate" => "user_sessions#admin_as_affiliate"
  match "/admin_logout_as_affiliate" => "user_sessions#admin_logout_as_affiliate"  

  match "/product_price" => "orders#add_price_type"
  match "/submit_price_type" => "orders#submit_price_type"
  match "/admin/affiliate/:username" => "users#product_prices"
  match "/admin/affiliates/:id" => "users#product_prices_update"
  match "/suggest_price_type" => "users#suggest_prices"
  match "/update_versions" => "orders#update_versions"  
  match "/update_versions_for_series" => "orders#update_versions_for_series"  
  match "/update_versions_for_prices" => "orders#update_versions_for_prices"  
  match "/update_versions_for_carrier" => "orders#update_versions_for_carrier"
  match "/delete_affiliate_product/:id/:user_id" => "user_sessions#delete_affiliate_product"
  match "/order_lists" => "orders#order_list"
  match "/order_search" => "orders#search_filter"
  match "/affiliates/orders" => "orders#order_by_sub_affiliates"
  match "/cancel/:id/order" => "orders#cancel_order"
    
  match "/affiliates/users" => "orders#sub_affiliates"
  match "/affiliate/users/:id" => "orders#show_sub_affiliates" #show page for affiliate user
  match "/affiliates/pricing" => "orders#order_pricing"
   
  match "/affiliate/users/:id/edit" => "orders#edit_sub_affiliates"
  match "/affiliate/users/:id/delete" => "orders#delete_sub_affiliates"
  match "/affiliates/users/new" => "orders#new_sub_affiliates"
  match "/affiliates/create" => "orders#create_sub_affiliates"
  match "/affiliates/update/:id" => "orders#update_sub_affiliates"
  match "/affilate/search" => "orders#sub_affiliates"
  
  resources :question_response
  resources :categories
  resources :carriers
  resources :catologues  
  resources :series_lists
  
  resources :categories do
    get :grades, :on => :member
  end
  
  
  
  # checkout wizard
  match 'carrier_product' => 'categories#carrier_product'
  match "/get_by_javascript"  => 'categories#get_manufacturer'

  match 'manufact_carrier' => 'manufacturers#manufacturer_carrier'
  match 'product_list' => 'categories#carrier_product'

  resources :checkout_steps
  match 'checkout_steps/done', :controller => :checkout_steps, :action => :done
  
  resources :shipping_requests
  
  match 'shipping_details/confirm', :controller => :shipping_details, :action => :confirm

  match 'products/show/' => 'products#show' # For the homepage form
  match "/showdata" => "shipping_details#showdata"
  match "/updatedata" => "shipping_details#updatedata"
  
  resources :products do
    resources :question_responses
  end

  match 'products/:id/offer' => 'products#offer'
  match 'create_return_label' => 'shipping_details#create_return_label'
  match 'create_shipping_label' => 'shipping_details#create_shipping_label'
  
  resources :manufacturers
  match 'search', :controller => "products", :action => "search"
  match 'get_quote'     => 'products#get_quote'
  match 'accept_quote'  => 'products#accept_quote'
  
  match 'question_responses' => 'products#get_quote'
  
  match 'orders' => 'shipping_details#orders'
  match 'orders/submit' => 'shipping_details#submit_external_order'
  match 'orders/checkout' => 'shipping_details#checkout'
  match 'orders/:id' => 'shipping_details#order_details'
  
  match 'customers/:id' => 'shipping_details#customers'

  match 'admin' => 'admin#index'
  match 'home' => 'home#index'
  match 'dev' => 'home#index'
  match 'root' => 'home#index'

  get "home/show"
  root :to => "home#index"  
  get 'home/autocomplete_product_name'
  
  resources :users, :user_sessions
  
  match '/affiliate' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy', :as => :logout

  match 'corporate' => 'corporate#index'
  match 'go_green' => 'go_green#index'
  match 'get_paid' => 'get_paid#index'
  match 'how_it_works' => 'how_it_works#index'
  
  match 'privacy_policy' => 'privacy_policy#index'
  
  match 'contact' => 'contact#index'
  
end
