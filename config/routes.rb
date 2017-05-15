Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'users#create'
      get 'active', to: 'users#active'
      post 'login', to: 'users#login'
      resources :users
      get 'products', to: 'products#index'
      get 'ratings', to: 'products#avg_ratings'
      get 'reviews/:id', to: 'products#reviews'
      get 'product/:id', to: 'products#show'
      get 'products/price', to: 'products#sort_price'
      get 'products/price_high', to: 'products#sort_price_high'
      get 'products/rating', to: 'products#sort_rating'
      get 'amazon/:id', to: 'products#amazon'
    end
  end
end
