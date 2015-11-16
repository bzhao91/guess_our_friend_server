class FriendPool < ActiveRecord::Base
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :game_id, presence: true
end
