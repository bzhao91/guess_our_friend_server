class AddUserRefToQuestions < ActiveRecord::Migration
  def change
    #add_reference :questions, :users, index: true, foreign_key: true
  end
end
