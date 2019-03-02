class AddResolvedToIssueReport < ActiveRecord::Migration
  def change
    add_column :issue_reports, :resolved, :boolean, default: false, null: false
  end
end
