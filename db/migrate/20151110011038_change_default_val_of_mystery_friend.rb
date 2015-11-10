class ChangeDefaultValOfMysteryFriend < ActiveRecord::Migration
  def change
    change_column :games, :mystery_friend1, :integer, :default => -1
    change_column :games, :mystery_friend2, :integer, :default => -1
  end
end
