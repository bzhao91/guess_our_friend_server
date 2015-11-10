class AddMysteryFriendsToGame < ActiveRecord::Migration
  def change
    add_column :games, :mystery_friend1, :integer #player2's target
    add_column :games, :mystery_friend2, :integer #player1's target
  end
end
