class ChangeReferenceOfUserToQuestions < ActiveRecord::Migration
  def change
    #remove_reference :questions, :users
    add_reference :questions, :user, :index => true
  end
end
