class CreateFriendPools < ActiveRecord::Migration
  def change
    create_table :friend_pools do |t|
      t.references :user, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.boolean :grey

      t.timestamps null: false
    end
  end
end
