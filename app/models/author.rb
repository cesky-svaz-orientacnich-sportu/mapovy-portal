# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: authors
#
#  id            :integer          not null, primary key
#  note          :string(255)
#  full_name     :string(255)
#  club          :text
#  activity      :string(255)
#  year_of_birth :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Author < ActiveRecord::Base

  has_many :cartographers, dependent: :destroy
  has_many :maps, ->{ group('maps.id') }, through: :cartographers
  scope :sorted, ->{ order(:full_name) }

  def to_s
    full_name
  end

  def to_label
    "#{full_name} (#{(club || '').truncate(15)} | #{activity})"
  end
  
  def update_activity
    y = maps.where('year > 0').group(:year).pluck(:year)
    if y.any?
      y1, y2 = y.min, y.max
      act = if y1 == y2
        "#{y1}"
      else
        "#{y1} - #{y2}"
      end
      update_attribute :activity, act
    end    
    cx = maps.where('patron IS NOT NULL').group(:patron).pluck(:patron)
    if cx.any?
      act = cx.uniq.sort * ", "
      update_attribute :club, act
    end    
  end

end
