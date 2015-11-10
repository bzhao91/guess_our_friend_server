class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.integer :answer

      t.timestamps null: false
    end
  end
end
