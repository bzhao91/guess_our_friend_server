class Question < ActiveRecord::Base
  validates :content, presence: true
  validates :user_id, presence: true
  validates :game_id, presence: true
end
