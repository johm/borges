Borges::Application.routes.draw do


  resources :text_fragments


  resources :inventory_copy_confirmations do 
    member do
      post :probablyreturned
    end
  end


  resources :inventories do
    member do 
      get :section
      get :owner
      post :fill
      post :fill_books
    end
  end

  resources :event_shifts


  resources :event_staffers do
    get :autocomplete_event_staffer_name, :on => :collection
  end

  get '/events/:id'=> 'events#redirector',  :constraints => { :id => /[0-9]+/ }
  resources :events do 
    get :autocomplete_event_location_title, :on => :collection
  end


  resources :event_locations


  resources :category_title_list_memberships


  resources :sale_order_line_items

 
  resources :sale_orders do
    member do
      post :post
    end
  end

  resources :return_order_line_items

 
  resources :return_orders do
    member do
      post :post
    end

  end



  resources :owners do
    get :autocomplete_owner_name, :on => :collection
  end


  resources :title_category_memberships


  get '/categories/:id'=> 'categories#redirector',  :constraints => { :id => /[0-9]+/ }
  resources :categories do 
    member do 
      get :chart
    end
  end

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


#  mount Ckeditor::Engine => '/ckeditor'

  resources :pages  do 
    get :autocomplete_parent_title, :on => :collection
  end


  resources :publishers do 
    member do
      put :merge_editions_from
    end
  end


  resources :customers do 
    get :autocomplete_customer_name, :on => :collection
  end


  resources :distributors do
    member do
      put :merge_orders_from
      get :chart
    end
  end



  resources :invoice_line_items

  get 'invoices/chart' => 'invoices#chart'
  resources :invoices do
    member do
      post :receive
    end
  end


  resources :purchase_order_line_items do 
    member do
      get :hidden_actions 
      put :move_to_purchase_order
      post :cancel
    end
  end


  resources :purchase_orders do 
    member do
      get :hidden_actions 
      post :submit
      post :receive
      post :cancel
      put :smartdestroy
    end
    get :autocomplete_distributor_name, :on => :collection
    resources :purchase_order_line_items
  end


  resources :copies do 
    get :autocomplete,:on => :collection
    get :inventory_autocomplete,:on => :collection
    member do
      post :mark_lost
    end

  end


  resources :editions do
    resources :copies
    get :autocomplete,:on => :collection
    get :autocomplete_title_title, :on => :collection
    member do
      get :hidden_actions 
      put :add_to_purchase_order
      put :add_to_title_list
      put :add_to_category
      get :bookshop
    end
  end


  resources :contributions do 
    get :autocomplete_author_full_name, :on => :collection
  end

  get 'titles/search' => 'titles#search'
  get '/titles/:id'=> 'titles#redirector',  :constraints => { :id => /[0-9]+/ }

  resources :titles do 
    get :autocomplete_publisher_name, :on => :collection
    get :autocomplete_distributor_name, :on => :collection
    get :autocomplete_title_list_name, :on => :collection
    get :autocomplete_category_name, :on => :collection

  end


  
  get 'authors/search' => 'authors#search'
  get '/authors/:id'=> 'authors#redirector',  :constraints => { :id => /[0-9]+/ }
  resources :authors

  resources :shopping_carts do
    collection do
      post :garbagecollect
    end
    member do
      post :complete
      post :toggle_pulled
      post :toggle_sold_through
      post :toggle_shipped
      post :toggle_picked_up
      post :toggle_pickup_notify
      post :toggle_is_preorder
      post :toggle_needs_attention
      post :defer
      post :ship
      post :subscribe
    end
  end

  resources :shopping_cart_line_items do
    member do
      post :split
    end
  end
  
  get '/book/:isbn', :to => 'editions#byisbn'
  get '/book/', :to => 'editions#byisbn'

  get '/dashboard/search', :to => 'dashboard#search'
  get '/dashboard/:action', :to => 'dashboard'
  get '/dashboard/', :to => 'dashboard#index'
  get '/content/', :to => 'dashboard#content'
  get '/sales/', :to => 'dashboard#sales'
  get '/losses/', :to => 'dashboard#losses'
  get '/events_calendar', :to => 'events#calendar'
  get '/consignment/', :to => 'dashboard#consignment'
  get '/ownerflow/', :to => 'dashboard#ownerflow'
  get '/purchases_by_date_and_owner/', :to => 'dashboard#purchases_by_date_and_owner'
  get '/inventory_value_by_date_and_owner/', :to => 'dashboard#inventory_value_by_date_and_owner'
  get '/inventory_report_by_owner/', :to => 'dashboard#inventory_report_by_owner'
  get '/daily/', :to => 'dashboard#daily', :as => "daily"
  get '/manage_calendar/', :to => 'dashboard#manage_calendar'
  get '/books/', :to => 'home#books'
  get '/food/', :to => 'home#food'
  get '/comingsoon/', :to => 'home#comingsoon'
  get '/gcl/', :to => redirect("https://www.threadcoffee.com/greenmount-coffee-lab/")
  get '/coffee/', :to => 'home#coffee'
  get '/orderfoodonline/', :to => 'home#orderfoodonline'
  get '/thread/', :to => 'home#thread'
  get '/blog/', :to => 'posts#index'
  get '/about/', :to => 'home#about'
  get '/2640/', :to => 'events#twentysixforty'
  get '/newsletter/', :to => 'home#newsletter'
  get '/promotion/antifa', :to => 'home#promotion'
  get '/pages/about/', :to => 'home#about'
  get '/cart', :to => "shopping_carts#current"
  get '/shopping_cart_success', :to => "shopping_carts#success"
  post '/webhook', :to => "shopping_carts#webhook"
  put '/update_cart', :to => "shopping_carts#update_current"
  put '/create-checkout-session', :to => "shopping_carts#checkout"
  match '/bookfair' => 'event_locations#show',:defaults => {:id => 4}
  authenticated :user do
    root :to=>'home#frontpage' 
  end
  root :to=>'home#frontpage' 

  devise_for :users
  resources :users
end
