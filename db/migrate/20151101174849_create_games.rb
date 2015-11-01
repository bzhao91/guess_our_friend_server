class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1id
      t.integer :player2id

      t.timestamps null: false
    end
  end
end
