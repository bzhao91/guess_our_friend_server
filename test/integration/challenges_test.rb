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
    get '/user', nil, {'HTTP_AUTHORIZATION' => @token}
    assert_equal 200, response.status
    logged_in_user = JSON.parse(response.body)
    return logged_in_user
  end
end