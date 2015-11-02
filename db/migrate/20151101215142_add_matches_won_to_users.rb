class AddMatchesWonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :matches_won, :integer, :default => 0
  end
end
