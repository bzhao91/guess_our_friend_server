class AddRatingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rating, :decimal, :default => 0
  end
end
