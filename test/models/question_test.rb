require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @question = Question.new(content: "Is he tall?", user_id: 3, game_id: 2)
  end
  
  test "should be valid" do
    assert @question.valid?
  end
  
  test "content should be present" do
    @question.content = "   "
    assert_not @question.valid?
  end

  test "user_id should be present" do
    @question.user_id = nil
    assert_not @question.valid?
  end
  
  test "game_id should be present" do
    @question.game_id = nil
    assert_not @question.valid?
  end
end
