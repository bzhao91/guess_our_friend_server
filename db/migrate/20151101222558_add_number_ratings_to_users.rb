class AddNumberRatingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_ratings, :integer, :default => 0
  end
end
