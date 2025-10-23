# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  link       :string(255)
#  name       :string(255)
#  provider   :string(255)
#  secret     :string(255)
#  token      :text
#  uid        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Authorization < ApplicationRecord

  #attr_accessible :link, :name, :provider, :secret, :token, :uid, :user_id

  belongs_to :user, :touch => true
  validates :provider, :uid, :presence => true

end
