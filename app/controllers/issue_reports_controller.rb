# == Schema Information
#
# Table name: issue_reports
#
#  id         :integer          not null, primary key
#  map_id     :integer
#  user_id    :integer
#  email      :string(255)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#  resolved   :boolean          default(FALSE), not null
#

class IssueReportsController < ApplicationController
  
  def new
    @issue_report = IssueReport.new(user_id: (current_user && current_user.id), email: (current_user && current_user.email), map_id: params[:map_id])
  end
  
  def create
    IssueReport.create(params[:issue_report])
  end
  
  def resolve
    @issue_report = IssueReport.find(params[:id])
    @issue_report.update_attribute :resolved, true
  end
  
end
