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

module IssueReportsHelper
end
