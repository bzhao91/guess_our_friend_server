require 'test_helper'
class FriendPoolsTest < ActionDispatch::IntegrationTest
  
  def setup
    post '/users', user: { first_name: "challenger",
                           last_name: "test",
                           fb_id: "challenger"
                          }
    assert_equal 200, response.status
    @challenger = JSON.parse(response.body)["user"]
    @challenger_token = JSON.parse(response.body)["token"]
   
    post '/users', user: { first_name: "challengee",
                           last_name: "test",
                           fb_id: "challengee"
                         }
    assert_equal 200, response.status
    @challengee = JSON.parse(response.body)["user"]
    @challengee_token = JSON.parse(response.body)["token"]
    @game = create_game
  end
   
  def login(token)
    get '/user', nil, {'HTTP_AUTHORIZATION' => token}
    assert_equal 200, response.status
    logged_in_user = JSON.parse(response.body)
    return logged_in_user
  end
  
  def create_challenge
    post '/challenges', {challengee_fb_id: @challengee["fb_id"]}, {'HTTP_AUTHORIZATION' => @challenger_token}
    assert_equal 200, response.status
    return JSON.parse(response.body)
  end
  
  def create_game
    challenge = create_challenge
    delete '/challenge/respond_as_challengee', {accept: true, challenger_id: challenge["challenger_id"], challenge_id: challenge["id"]},{'HTTP_CONTENT-TYPE'=> 'application/json', 'HTTP_ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => @challengee_token}
    assert_equal 200, response.status
    return JSON.parse(response.body)
  end
  
  test "create a challenge" do
    assert_difference 'Challenge.count', 1 do
      create_challenge
    end
  end


  test "commit a friend pool as a challengee" do
    assert_difference 'FriendPool.count', 2 do
      fp1 = {first_name: "t1", last_name: "u", mystery_friend: true}
      fp = []
      fp << fp1
      fp2 = {first_name: "t2", last_name: "u"}
      fp << fp2
      post '/friend_pools', {game_id: @game['id'], friend_pool: fp}, {'HTTP_AUTHORIZATION' => @challengee_token}
      assert_equal 200, response.status
      get '/user/all_games', nil, {'HTTP_AUTHORIZATION' => @challengee_token}
      assert_equal 200, response.status
      assert_equal 1, JSON.parse(response.body)['results']['incoming_games'].count
      #retrive game board to check if mystery friend has been commited
      get '/game_board', {game_id: @game['id']}, {'HTTP_AUTHORIZATION' => @challengee_token}
      assert_equal 200, response.status
      assert_not_equal nil, JSON.parse(response.body)['results']['mystery_friend']
    end
  end
  
  test "commit a friend pool as a challenger" do
    assert_difference 'FriendPool.count', 2 do
      fp1 = {first_name: "t3", last_name: "u", mystery_friend: true}
      fp = []
      fp << fp1
      fp2 = {first_name: "t4", last_name: "u"}
      fp << fp2
      post '/friend_pools', {game_id: @game['id'], friend_pool: fp}, {'HTTP_AUTHORIZATION' => @challenger_token}
      assert_equal 200, response.status
      get '/user/all_games', nil, {'HTTP_AUTHORIZATION' => @challenger_token}
      assert_equal 200, response.status
      assert_equal 1, JSON.parse(response.body)['results']['outgoing_games'].count
      #retrive game board to check if mystery friend has been commited
      get '/game_board', {game_id: @game['id']}, {'HTTP_AUTHORIZATION' => @challenger_token}
      assert_equal 200, response.status
      assert_not_equal nil, JSON.parse(response.body)['results']['mystery_friend']
    end
  end
end