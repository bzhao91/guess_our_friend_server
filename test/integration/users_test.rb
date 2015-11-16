require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    post '/users', user: { first_name: "globalUser",
                           last_name: "test",
                           fb_id: "globaltest"
                          }
    assert_equal 200, response.status
    @user = JSON.parse(response.body)["user"]
   
    @token = JSON.parse(response.body)["token"]
  end
  
  def login(token)
    get '/user', nil, {'HTTP_AUTHORIZATION' => @token}
    assert_equal 200, response.status
    logged_in_user = JSON.parse(response.body)
    return logged_in_user
  end
  
  test "should be able to log in with token" do
    logged_in_user = login(@token)
    assert_equal @user["fb_id"], logged_in_user["fb_id"]
  end

  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post '/users', user: { first_name:  "",
                             last_name: "", 
                             fb_id: ""}
    end
  end
  
  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post '/users', user: { first_name:  "test",
                             last_name: "user", 
                             fb_id: "testuser2"}
      user = JSON.parse(response.body)
      assert_equal "test", user["user"]["first_name"]
      assert_equal "user", user["user"]["last_name"]
    end
  end
  
  test "duplicate fb_id signup" do
    assert_no_difference 'User.count' do
      post '/users', user: { first_name:  "test",
                             last_name: "user", 
                             fb_id: "testuser"}
    end
  end
  
  test "update gcm" do
    original_gcm_id = login(@token)["gcm_id"]
    
    put '/user/gcm_id', {gcm_id: "#{original_gcm_id}new gcm id"}, {'HTTP_AUTHORIZATION' => @token}
    assert_equal 200, response.status
    new_gcm_id = login(@token)["gcm_id"]
    assert_equal "#{original_gcm_id}new gcm id", new_gcm_id
  end
end