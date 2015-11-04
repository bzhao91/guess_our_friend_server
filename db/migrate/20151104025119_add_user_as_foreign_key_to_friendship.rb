class AddUserAsForeignKeyToFriendship < ActiveRecord::Migration
  def change
    add_foreign_key :friendships, :users
  end
end
