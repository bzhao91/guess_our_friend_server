require 'test_helper'

class FriendPoolTest < ActiveSupport::TestCase
  def setup
    @friend_pool = FriendPool.new(first_name: "Example", last_name: "User", game_id: 2, user_id: 3)
  end
  
  test "should be valid" do
    assert @friend_pool.valid?
  end
  
  test "first_name should be present" do
    @friend_pool.first_name = ""
    assert_not @friend_pool.valid?
  end
  
  test "last_name should be present" do
    @friend_pool.last_name = " "
    assert_not @friend_pool.valid?
  end
  
  test "game_id should be present" do
    @friend_pool.game_id = nil
    assert_not @friend_pool.valid?
  end
  
  test "user_id should be present" do
    @friend_pool.user_id = nil
    assert_not @friend_pool.valid?
  end
  
  test "first_name should not be too long" do
    @friend_pool.first_name = "a"*51
    assert_not @friend_pool.valid?
  end
  
  test "last_name should not be too long" do
    @friend_pool.last_name = "b"*51
    assert_not @friend_pool.valid?
  end
  
end
