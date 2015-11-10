class ChangeReferenceOfGameToQuestions < ActiveRecord::Migration
  def change
    remove_reference :questions, :games
    add_reference :questions, :game, :index => true
  end
end
