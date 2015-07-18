Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/failure'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to: "pages#index"

  # get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'

  scope :api, defaults: {format: 'json'} do
    get 'me' => 'me#index'
    get 'user/is_authorized' => 'me#is_authorized'
    get 'user/:id' => 'users#show', :constraints => { :id => /[^\/]+/ }
    get 'notifications' => 'notifications#index'
    post 'notifications' => 'notifications#mark_seen'
    get 'stream' => 'stream#index'
    get 'films' => 'films#index'
    get 'films/trailer/:tmdb_id' => 'films#trailer'
    get 'films/nowplaying' => 'films#now_playing'
    get 'films/search/:query' => 'films#search'
    get 'users/search/:query' => 'users#search'
    post 'follow/:follower_id' => 'followers#follow'
    post 'unfollow/:follower_id' => 'followers#unfollow'

    get 'watchlists' => 'watchlists#index'
    post 'watchlists/add_remove' => 'watchlists#add_remove'

    resources :custom_lists, path: 'lists'
    resources :rating_types
    resources :reviews
  end
  

  get '*path', to: "pages#index"
end
