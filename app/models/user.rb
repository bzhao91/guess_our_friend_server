class User < ActiveRecord::Base
 before_save { fb_id.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :fb_id, presence: true, uniqueness: {case_sensitive: false}
  #has_secure_password
  #validates :password, length: { minimum: 6 }
end
