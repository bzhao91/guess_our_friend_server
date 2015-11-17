require 'test_helper'
class ChallengesTest < ActionDispatch::IntegrationTest
  
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
  
  test "create a valid challenge" do
    assert_difference 'Challenge.count', 1 do
      create_challenge
    end
  end

  test "respond to a challenge as a challenger" do
    challenge = create_challenge
    assert_difference 'Challenge.count', -1 do
      delete '/challenge/respond_as_challenger', {challengee_id: challenge["challengee_id"], challenge_id: challenge["id"]}, {'HTTP_AUTHORIZATION' => @challenger_token}
      assert_equal 200, response.status
    end
  end
  
  test "respond to a challenge as a challengee - decline" do
    challenge = create_challenge
    assert_difference 'Challenge.count', -1 do
      delete '/challenge/respond_as_challengee', {accept: false, challenger_id: challenge["challenger_id"], challenge_id: challenge["id"]}, {'HTTP_CONTENT-TYPE'=> 'application/json', 'HTTP_ACCEPT' => 'application/json','HTTP_AUTHORIZATION' => @challengee_token}
      assert_equal 200, response.status

    end
  end
  test "respond to a challenge as a challengee - accept" do
    challenge = create_challenge
    assert_difference 'Challenge.count', -1 do
      assert_difference 'Game.count', 1 do
        delete '/challenge/respond_as_challengee', {accept: true, challenger_id: challenge["challenger_id"], challenge_id: challenge["id"]},{'HTTP_CONTENT-TYPE'=> 'application/json', 'HTTP_ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => @challengee_token}
        assert_equal 200, response.status
      end
    end
  end
end