class ChangeBadGuessInQuestions < ActiveRecord::Migration
  def change
    rename_column :games, :bad_guess, :questions_left
    change_column :games, :questions_left, :integer, :default => 1
  end
end
