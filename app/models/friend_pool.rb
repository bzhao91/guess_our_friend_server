class FriendPool < ActiveRecord::Base
  belongs_to :game
  validates :user_id, presence: true
  
  validates :game_id, presence: true
end
