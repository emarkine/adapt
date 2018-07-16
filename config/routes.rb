Rails.application.routes.draw do
  root to: 'site#index'

  resources :users
  get '/user/sort/:field' => 'users#sort'

  resources :user_sessions
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
  get 'profile' => 'users#profile'

  resources :nodes
  get '/node/sort/:field' => 'nodes#sort'

  resources :services
  get '/service/sort/:field' => 'services#sort'
  get '/service/:id/action/:name' => 'services#action'
  get '/service/:id/status' => 'services#status'
  get '/services/group/:name' => 'services#group'
  get '/services/frame/:name' => 'services#frame'
  get '/services/host/:name' => 'services#host'
  get '/service/show_history' => 'services#show_history'
  get '/service/show_all' => 'services#show_all'
  get '/service/hide_all' => 'services#hide_all'

  resources :funds
  # get '/funds/:id/rate' => 'funds#rate'
  # post '/funds/:id/select_date' => 'funds#select_date'
  # post '/funds/:id/change_refresh' => 'funds#change_refresh'
  # match '/fund/sort/:field' => 'funds#sort', via: :get
  # post '/funds/:id/frame' => 'funds#frame'
  # get '/funds/:id/draw' => 'funds#draw'
  # get '/funds/:id/toolbar/:name' => 'funds#toolbar'
  # get '/funds/:id/watch' => 'funds#watch'
  # post '/funds/:id/scroll' => 'funds#scroll'

  # вспомогательные ресурсы без вьюх
  resources :settings
  resources :frames
  resources :states
  resources :hosts
  resources :parts

end
