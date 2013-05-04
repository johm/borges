Borges::Application.routes.draw do
  resources :invoice_line_items


  resources :invoices


  resources :purchase_order_line_items


  resources :purchase_orders


  resources :copies


  resources :editions


  resources :contributions do 
    get :autocomplete_author_full_name, :on => :collection
  end


  resources :titles


  resources :authors


  authenticated :user do
    root :to => 'home#index'
  end
  match 'frontpage', :to=>'home#frontpage'
  root :to => "home#index"
  devise_for :users
  resources :users
end
