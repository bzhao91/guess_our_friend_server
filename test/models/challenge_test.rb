require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @challenge = Challenge.new(challengee_id: 3, challenger_id: 4)
  end
  
  test "should be valid" do
    assert @challenge.valid?
  end
  
  test "challenger_id should be present" do
    @challenge.challenger_id = nil
    assert_not @challenge.valid?
  end
  
  test "challengee_id should be present" do
    @challenge.challengee_id = nil
    assert_not @challenge.valid?
  end
  
  test "A challenger can only has one pending challenge with a challengee" do
    challenge_dup = @challenge.dup
    @challenge.save
    assert_not challenge_dup.valid?
    challenge_differnt_challengee = Challenge.new(challengee_id: 5, challenger_id: 4)
    assert challenge_differnt_challengee.valid?
  end
  
  
  test "A challengee can only has one pending challenge with a challenger" do
    challenge_dup = @challenge.dup
    @challenge.save
    assert_not challenge_dup.valid?
    challenge_differnt_challenger = Challenge.new(challengee_id: 3, challenger_id: 5)
    assert challenge_differnt_challenger.valid?
  end
end
