class FriendPool < ActiveRecord::Base
  validates :user_id, presence: true
  validates :game_id, presence: true
end
