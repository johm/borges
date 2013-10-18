Borges::Application.routes.draw do
  resources :sale_order_line_items

 
  resources :sale_orders do
    member do
      post :post
    end

  end


  resources :owners do
    get :autocomplete_owner_name, :on => :collection
  end


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

  resources :invoices do
    member do
      post :receive
    end
  end


  resources :purchase_order_line_items


  resources :purchase_orders do 
    member do
      post :submit
      post :receive
    end
    get :autocomplete_distributor_name, :on => :collection
    resources :purchase_order_line_items
  end


  resources :copies do 
    get :autocomplete,:on => :collection
  end


  resources :editions do
    resources :copies
    get :autocomplete,:on => :collection
    get :autocomplete_title_title, :on => :collection
    member do
      get :hidden_actions 
      put :add_to_purchase_order
    end
  end


  resources :contributions do 
    get :autocomplete_author_full_name, :on => :collection
  end

  get 'titles/search' => 'titles#search'
  resources :titles do 
    get :autocomplete_publisher_name, :on => :collection
    get :autocomplete_distributor_name, :on => :collection
    get :autocomplete_title_list_name, :on => :collection
    get :autocomplete_category_name, :on => :collection

  end


  
  get 'authors/search' => 'authors#search'
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
