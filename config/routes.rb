Rails.application.routes.draw do
  get 'games/new'

  get 'challenges/new'

  get 'friend/new'

  resources :users
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
