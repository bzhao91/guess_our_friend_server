class User < ActiveRecord::Base
  before_save { fb_id.downcase! }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :fb_id, presence: true, uniqueness: {case_sensitive: false}
  validates :last_name, presence: true, length: { maximum: 50}
  has_many :sending_challenges, class_name:  "Challenge",
                                  foreign_key: "challenger_id",
                                  dependent: :destroy
  has_many :challengeds, through: :sending_challenges, source: :challengee
  has_many :receiving_challenges, class_name:  "Challenge",
                                  foreign_key: "challengee_id",
                                  dependent: :destroy                      
  has_many :challenged_bys, through: :receiving_challenges, source: :challengers
  has_many :friends, class_name:  "Friendship",
                                  foreign_key: "user_id",
                                  dependent: :destroy
  has_many :friendships
end
