class AddMatchesLostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :matches_lost, :integer, :default => 0
  end
end
