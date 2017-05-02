Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'users#create'
      get 'active', to: 'users#active'
      post 'login', to: 'users#login'
      resources :users
    end
  end
end
