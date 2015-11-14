class AddRegIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :reg_id, :string
  end
end
