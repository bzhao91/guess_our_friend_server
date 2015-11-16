require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(first_name: "Example", last_name: "User", fb_id: "facebook_id")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "first_name should be present" do
    @user.first_name = ""
    assert_not @user.valid?
  end
  
  test "last_name should be present" do
    @user.last_name = " "
    assert_not @user.valid?
  end
  
  test "fb_id should be present" do
    @user.fb_id = " "
    assert_not @user.valid?
  end
  
  test "first_name should not be too long" do
    @user.first_name = "a"*51
    assert_not @user.valid?
  end
  
  test "last_name should not be too long" do
    @user.last_name = "b"*51
    assert_not @user.valid?
  end
  
  test "fb_id should be unique" do
   duplicate_user = @user.dup
   @user.save
   assert_not duplicate_user.valid?
  end
end
