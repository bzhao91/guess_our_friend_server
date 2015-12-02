class AddMatchMakingTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :match_making, :datetime, :default => nil
  end
end
