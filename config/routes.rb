Rails.application.routes.draw do
  resources :users, defaults: {format: :json}
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
