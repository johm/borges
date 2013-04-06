Borges::Application.routes.draw do
  resources :contributions


  resources :titles


  resources :authors


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end