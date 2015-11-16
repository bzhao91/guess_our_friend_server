class AddFirstNameLastNameToFriendPool < ActiveRecord::Migration
  def change
    add_column :friend_pools, :first_name, :string
    add_column :friend_pools, :last_name, :string
  end
end
