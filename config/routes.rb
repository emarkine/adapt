Rails.application.routes.draw do
  root to: 'site#index'
  resources :user_sessions
  resources :users
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
  get 'profile' => 'users#profile'

  resources :nodes
  get '/node/sort/:field' => 'nodes#sort'

  resources :services
  get '/node/service/:field' => 'services#sort'

end
