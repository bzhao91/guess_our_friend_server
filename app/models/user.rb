class User < ActiveRecord::Base
  before_save { fb_id.downcase! }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :fb_id, presence: true, uniqueness: {case_sensitive: false}
  validates :last_name, presence: true, length: { maximum: 50}
end
