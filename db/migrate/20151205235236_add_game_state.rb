class AddGameState < ActiveRecord::Migration
  def change
    add_column :games, :state, :integer, :default => 0 #0 is beginning when not both mystery friends are selected, 1 is in the middle of the game, 2 is the end of the game 
  end
end
