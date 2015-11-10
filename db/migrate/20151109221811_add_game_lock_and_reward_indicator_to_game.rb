class AddGameLockAndRewardIndicatorToGame < ActiveRecord::Migration
  def change
    add_column :games, :lock, :boolean, :default => false
    add_column :games, :bad_guess, :boolean, :default => false
  end
end
