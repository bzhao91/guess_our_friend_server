class User < ActiveRecord::Base
  before_save { fb_id.downcase! }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :fb_id, presence: true, uniqueness: {case_sensitive: false}
  validates :last_name, presence: true, length: { maximum: 50}
  has_many :friends, class_name:  "Friendship",
                                  foreign_key: "user_id",
                                  dependent: :destroy
  has_many :friendships
end
