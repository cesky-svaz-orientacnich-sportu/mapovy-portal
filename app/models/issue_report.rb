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

class IssueReport < ApplicationRecord
  belongs_to :map
  belongs_to :user, optional: true
  scope :unresolved, ->{ where(resolved: false) }
  scope :resolved, ->{ where(resolved: true) }
end
