class ChangeColNameOfRegId < ActiveRecord::Migration
  def change
    rename_column :users, :reg_id, :gcm_id
  end
end
