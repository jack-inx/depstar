Trunk::Application.routes.draw do

  match 'search' => 'categories#search_filter'  
  match 'categories/show/' => 'categories#show' # For the homepage form
  
  resources :question_response
  resources :categories
  resources :carriers
  
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
  
  resources :shipping_details
  match 'shipping_details/confirm', :controller => :shipping_details, :action => :confirm

  match 'products/show/' => 'products#show' # For the homepage form
  
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
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  match 'corporate' => 'corporate#index'
  match 'go_green' => 'go_green#index'
  match 'get_paid' => 'get_paid#index'
  match 'how_it_works' => 'how_it_works#index'
  
  match 'privacy_policy' => 'privacy_policy#index'
  
  match 'contact' => 'contact#index'
  
end
