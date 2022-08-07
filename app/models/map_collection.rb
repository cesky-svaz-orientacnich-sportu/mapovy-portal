# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: map_collections
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  slug              :string(255)
#  description       :text
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class MapCollection < ApplicationRecord

  has_attached_file :logo, :styles => { :show => "200x200>", :thumb => "100x100#", :micro => "64x64#" }
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_many :map_collection_memberships, -> { order('map_collection_memberships.year') }, :dependent => :destroy
  has_many :maps, through: :map_collection_memberships
  accepts_nested_attributes_for :map_collection_memberships, :allow_destroy => true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def map_ids
    maps.pluck(:id)
  end

  def to_s
    title
  end

  def years
    map_collection_memberships.group(:year).pluck(:year).sort
  end

end
