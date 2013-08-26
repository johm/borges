Borges::Application.routes.draw do

  resources :sale_order_line_items
  resources :sale_orders
  resources :owners
  resources :title_category_memberships
  resources :categories
  resources :post_title_list_links
  resources :post_title_links
  resources :create_post_title_links
  resources :post_categories
  resources :posts
  resources :title_list_memberships

  resources :title_lists do 
    get :autocomplete_title_title, :on => :collection
    get :autocomplete_title_list_name, :on => :collection
  end

  resources :images

  mount Ckeditor::Engine => '/ckeditor'

  resources :pages  do 
    get :autocomplete_parent_title, :on => :collection
  end

  resources :publishers

  resources :customers do 
    get :autocomplete_customer_name, :on => :collection
  end

  resources :distributors
  resources :invoice_line_items
  resources :invoices
  resources :purchase_order_line_items
  resources :purchase_orders do 
    member do
      post :submit
    end
    get :autocomplete_distributor_name, :on => :collection
    resources :purchase_order_line_items
  end


  resources :copies
  resources :editions do
    get :autocomplete,:on => :collection
    get :autocomplete_title_title, :on => :collection
  end

  resources :contributions do 
    get :autocomplete_author_full_name, :on => :collection
  end

  get 'titles/search' => 'titles#search'
  resources :titles do 
    get :autocomplete_publisher_name, :on => :collection
    get :autocomplete_distributor_name, :on => :collection
    get :autocomplete_title_list_name, :on => :collection
  end

  resources :authors

  get '/dashboard/:action', :to => 'dashboard'
  get '/dashboard/', :to => 'dashboard#index'
  get '/content/', :to => 'dashboard#content'

  authenticated :user do
    root :to=>'home#frontpage' 
  end

  root :to=>'home#frontpage' 

  devise_for :users
  resources :users
end
