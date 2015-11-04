class RenameFriendshipColumns < ActiveRecord::Migration
  def change
    remove_column :friendships, :name
    add_column :friendships, :user_id, :integer
    add_column :friendships, :friend_id, :integer
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
