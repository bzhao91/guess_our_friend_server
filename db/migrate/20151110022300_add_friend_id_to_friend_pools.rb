class AddFriendIdToFriendPools < ActiveRecord::Migration
  def change
    add_column :friend_pools, :friend_id, :integer
  end
end
