class ChangeChallengeTable < ActiveRecord::Migration
  def change
    remove_column :challenges, :incoming, :boolean
    rename_column :challenges, :player1id, :challenger_id #sends out challenges
    rename_column :challenges, :player2id, :challengee_id #receives incoming challenges
    add_index :challenges, :challenger_id 
    add_index :challenges, :challengee_id
    add_index :challenges, [:challenger_id, :challengee_id], unique: true
    add_index :challenges, [:challengee_id, :challenger_id], unique: true
    add_index :friendships, [:friend_id, :user_id], unique: true
  end
end
