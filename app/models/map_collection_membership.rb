# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: map_collection_memberships
#
#  id                :integer          not null, primary key
#  map_id            :integer
#  map_collection_id :integer
#  year              :integer
#  note              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class MapCollectionMembership < ApplicationRecord
  belongs_to :map_collection
  belongs_to :map
end
