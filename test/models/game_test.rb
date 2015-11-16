require 'test_helper'

class GameTest < ActiveSupport::TestCase
  
 def setup
    @game = Game.new(player1id: 3, player2id: 4)
  end
  
  test "should be valid" do
    assert @game.valid?
  end
  
  test "player1id should be present" do
    @game.player1id = nil
    assert_not @game.valid?
  end
  
  test "player2id should be present" do
    @game.player2id = nil
    assert_not @game.valid?
  end
  

  
end
