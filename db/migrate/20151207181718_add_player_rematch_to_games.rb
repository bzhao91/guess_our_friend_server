class AddPlayerRematchToGames < ActiveRecord::Migration
  def change
    add_column :games, :player1rematch, :boolean, :default => false
    add_column :games, :player2rematch, :boolean, :default => false
  end
end
