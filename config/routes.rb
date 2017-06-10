Rails.application.routes.draw do
  root to: 'site#index'
  get 'login',  to: 'user_sessions#new', as: :login
  post 'login', to: 'user_sessions#create'
  get 'logout', to: 'user_sessions#destroy', as: :logout
  get '/profile', to: 'users#profile'
  resource :users
end
