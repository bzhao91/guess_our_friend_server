class ChangeColsOfFriendPools < ActiveRecord::Migration
  def change
    remove_column :friend_pools, :first_name, :string
    remove_column :friend_pools, :last_name, :string
    add_column :friend_pools, :fb_id, :string
  end
end
