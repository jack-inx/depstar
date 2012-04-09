Trunk::Application.routes.draw do
  
  resources :question_response
  resources :categories
  
  resources :categories do
    get :grades, :on => :member
  end
  
  resources :shipping_details
  match 'shipping_details/confirm', :controller => :shipping_details, :action => :confirm
  
  resources :products do
    resources :question_responses
  end
  
  match 'products/:id/offer' => 'products#offer'
  match 'products/:id/checkout' => 'products#checkout'
  
  resources :manufacturers
  match 'search', :controller => "products", :action => "search"
  match 'get_quote'     => 'products#get_quote'
  match 'accept_quote'  => 'products#accept_quote'
  
  match 'question_responses' => 'products#get_quote'
  
  match 'orders' => 'shipping_details#orders'
  match 'orders/submit' => 'shipping_details#submit_external_order'
  match 'orders/:id' => 'shipping_details#order_details'
  
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
  
  match 'contact' => 'contact#index'
end
