Rails.application.routes.draw do
  get 'games/new'

  get 'challenges/new'

  get 'friend/new'
  
  get 'user', to: 'users#show'
  post 'test_gcm', to: 'users#send_message'
  
  # put 'friend_list', to: 'friendships#update_friend_list'
  
  # put 'friend_status', to: 'friendships#friend_status'
  
  put 'user/update_rating', to: 'users#update_rating'
  
  put 'user/update_postmatch', to: 'users#update_postmatch'
  
  get 'user/outgoing_challenges', to: 'challenges#show_outgoing_challenges'
  
  get 'user/incoming_challenges', to: 'challenges#show_incoming_challenges'
  
  post 'friend_pools/set_mystery_friend', to: 'friend_pools#set_mystery_friend'
  
  get 'game_board', to: 'games#show_game_board'
  
  get 'user/all_games', to: 'games#show_all_games'
  
  post 'game/match_making', to: 'games#match_making'
  
  put 'game/remove_from_match_making', to: 'games#remove_from_match_making'
  
  get 'game/check_match_making', to: 'games#check_match_making'
  
  put 'game/set_done', to: 'games#set_done'
  
  put 'user/gcm_id', to: 'users#update_gcm_id'
  
  delete 'user', to: 'users#destroy'
  
  put 'game/player_quit', to: 'games#player_quit'
  
  get 'game/reveal', to: 'games#reveal_mystery_friend'
  
  resources :users
  #'user/:id' => users#show
  
  resources :challenges
  
  resources :games
  
  resources :friend_pools
  
  resources :bug_reports
  
  resources :questions
  post 'question/answer', to: 'questions#answer'
  post 'game/guess', to: 'questions#guess'
  put 'friend_pool/grey', to: 'games#grey_out'
  put 'friend_pool/ungrey', to: 'games#ungrey'
  
  delete 'challenge/respond_as_challengee', to: 'challenges#challengee_respond'
  delete 'challenge/respond_as_challenger', to: 'challenges#challenger_respond'
  #get '/users/nickname', to: 'users#get_nickname'
  #post '/usus/change_nickname', to: 'users#change_nickname'
end
