class AddActiveMoveToGames < ActiveRecord::Migration
  def change
     add_column :games, :active_move, :boolean, :default => true
  end
end
