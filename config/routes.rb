Rails.application.routes.draw do
  get 'games/new'

  get 'challenges/new'

  get 'friend/new'
  
  get 'user', to: 'users#show'
  
  put 'friend_list', to: 'friendships#update_friend_list'
  
  put 'unfriend', to: 'friendships#unfriend'
  
  put 'user/update_rating', to: 'users#update_rating'
  
  put 'user/update_postmatch', to: 'users#update_postmatch'
  
  
  resources :users
  #'user/:id' => users#show
  
  resources :challenges
  
  resources :games
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
