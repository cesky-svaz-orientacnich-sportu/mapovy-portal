# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  token      :string(255)
#  secret     :string(255)
#  name       :string(255)
#  link       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authorization < ActiveRecord::Base
  
  #attr_accessible :link, :name, :provider, :secret, :token, :uid, :user_id

  belongs_to :user, :touch => true
  validates :provider, :uid, :presence => true
  
end
