class AddDefaultValueToGrey < ActiveRecord::Migration
  def change
    change_column :friend_pools, :grey, :boolean, :default => false
  end
end
