class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :id
      t.integer :player1id
      t.integer :player2id

      t.timestamps null: false
    end
  end
end
