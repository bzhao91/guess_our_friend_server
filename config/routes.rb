Rails.application.routes.draw do
  get 'friend/new'

  resources :users
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
