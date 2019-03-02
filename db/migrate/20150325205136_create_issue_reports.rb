class CreateIssueReports < ActiveRecord::Migration
  def change
    create_table :issue_reports do |t|
      t.integer :map_id
      t.integer :user_id
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
