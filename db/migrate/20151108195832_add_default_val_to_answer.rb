class AddDefaultValToAnswer < ActiveRecord::Migration
  def change
    change_column :questions, :answer, :integer, :default => -1
  end
end
