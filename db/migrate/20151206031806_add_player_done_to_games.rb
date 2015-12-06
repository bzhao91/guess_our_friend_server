class AddPlayerDoneToGames < ActiveRecord::Migration
  def change
    add_column :games, :player1done, :boolean, :default => false
    add_column :games, :player2done, :boolean, :default => false
  end
end
