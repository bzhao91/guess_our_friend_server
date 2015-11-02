class AddIncomingToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :incoming, :boolean
  end
end
