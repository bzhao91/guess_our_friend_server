class AddIndexesToGame < ActiveRecord::Migration
  def change
    add_index :games, :player1id 
    add_index :games, :player2id
    add_index :games, [:player1id, :player2id], unique: true
    add_index :games, [:player2id, :player1id], unique: true
  end
end
