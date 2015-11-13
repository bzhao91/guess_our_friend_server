class CreateBugReports < ActiveRecord::Migration
  def change
    create_table :bug_reports do |t|
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
