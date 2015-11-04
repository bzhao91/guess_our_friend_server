Rails.application.routes.draw do
  get 'games/new'

  get 'challenges/new'

  get 'friend/new'
  
  put 'user/update_rating', to: 'users#update_rating'
  
  put 'user/update_postmatch', to: 'users#update_postmatch'
  
  put ''
  resources :users
  
  resources :challenges
  
  resources :games
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
