# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: clubs
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  abbreviation   :string(255)
#  region         :string(255)
#  district       :string(255)
#  url            :string(255)
#  division       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  oris_data_json :text
#  slug           :string(255)
#

class Club < ActiveRecord::Base

  paginates_per 20
  
  has_many :maps, :primary_key => :abbreviation, :foreign_key => :patron
  
  scope :sorted, ->{ order(:abbreviation) }
  validates_uniqueness_of :abbreviation
  
  extend FriendlyId
  friendly_id :abbreviation, use: [:slugged, :finders]

  def to_s
    s = "#{abbreviation}"
    s += " - #{name}" unless name.blank?
    s
  end
  
  def oris_link
    "https://oris.orientacnisporty.cz/Klub?id=#{abbreviation}"
  end
    
  def self.by_abbreviation(x)
    where(:abbreviation => x).first
  end
    
  def self.oris_url
    "https://oris.orientacnisporty.cz/API/?format=json&method=getCSOSClubList"
  end
  
  def oris_url
    "https://oris.orientacnisporty.cz/API/?format=json&method=getClub&id=#{abbreviation}"
  end
  
  def self.build
    require 'open-uri'
    puts "Opening #{oris_url}"
    data = open(oris_url).read rescue nil
    if data
      puts "Got data from ORIS"
      json = JSON[data] rescue nil
      if json and json['Status'] == 'OK'
        puts "Parsed data from oris"
        json["Data"].each do |abbreviation, xdata|
          name = xdata['Name']
          c = Club.where(:abbreviation => abbreviation).first || Club.create(:abbreviation => abbreviation)
          c.update_attribute(:name, name)
          puts "#{abbreviation} -> #{name}"
          c.get
        end
      end
    end    
  end

  def get
    require 'open-uri'
    data = open(oris_url).read rescue nil
    if data
      json = JSON[data] rescue nil
      if json and json['Status'] == 'OK'
        update_attribute(:oris_data_json, data)
      end
    end
    sleep 1
  end
  
  def oris_data
    return {} if oris_data_json.blank?
    @oris_data ||= JSON[oris_data_json]['Data']
  end
    
  

end
