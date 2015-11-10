Rails.application.routes.draw do
  get 'games/new'

  get 'challenges/new'

  get 'friend/new'
  
  get 'user', to: 'users#show'
  
  put 'friend_list', to: 'friendships#update_friend_list'
  
  put 'friend_status', to: 'friendships#friend_status'
  
  put 'user/update_rating', to: 'users#update_rating'
  
  put 'user/update_postmatch', to: 'users#update_postmatch'
  
  get 'user/outgoing_challenges', to: 'challenges#show_outgoing_challenges'
  
  get 'user/incoming_challenges', to: 'challenges#show_incoming_challenges'
  resources :users
  #'user/:id' => users#show
  
  resources :challenges
  
  resources :games
  
  resources :friend_pools
  delete 'challenge/respond_as_challengee', to: 'challenges#challengee_respond'
  delete 'challenge/respond_as_challenger', to: 'challenges#challenger_respond'
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
