Rails.application.routes.draw do
  resources :users
  #get '/users/nickname', to: 'users#get_nickname'
end
