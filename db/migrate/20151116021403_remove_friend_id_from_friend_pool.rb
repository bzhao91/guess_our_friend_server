class RemoveFriendIdFromFriendPool < ActiveRecord::Migration
  def change
      remove_column :friend_pools, :friend_id, :integer
  end
end
