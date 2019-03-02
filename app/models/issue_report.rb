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

class IssueReport < ActiveRecord::Base
  belongs_to :map
  belongs_to :user
  scope :unresolved, ->{ where(resolved: false) }
  scope :resolved, ->{ where(resolved: true) }
end
