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

class Club < ApplicationRecord

  paginates_per 20

  has_many :maps, :primary_key => :abbreviation, :foreign_key => :patron

  scope :sorted, ->{ order(:abbreviation) }
  validates_uniqueness_of :abbreviation

  extend FriendlyId
  friendly_id :abbreviation, use: [:slugged, :finders]

  PUBLIC_CLUBS = {
    "S00" => { "name" => "ČSOS",                                              },
    "S01" => { "name" => "Sekce OB ČSOS",                                     },
    "S02" => { "name" => "Sekce LOB ČSOS",                                    },
    "S03" => { "name" => "Sekce MTBO ČSOS",                                   },
    "S04" => { "name" => "Sekce Trail-O ČSOS",                                },
    "K01" => { "name" => "Pražský krajský svaz ČSOS",         "region" => "A" },
    "K02" => { "name" => "Středočeský krajský svaz ČSOS",     "region" => "S" },
    "K03" => { "name" => "Karlovarský krajský svaz ČSOS",     "region" => "K" },
    "K04" => { "name" => "Plzeňský krajský svaz ČSOS",        "region" => "P" },
    "K05" => { "name" => "Jihočeský krajský svaz ČSOS",       "region" => "C" },
    "K06" => { "name" => "Ústecký krajský svaz ČSOS",         "region" => "U" },
    "K07" => { "name" => "Liberecký krajský svaz ČSOS",       "region" => "L" },
    "K08" => { "name" => "Královéhradecký krajský svaz ČSOS", "region" => "H" },
    "K09" => { "name" => "Pardubický krajský svaz ČSOS",      "region" => "E" },
    "K10" => { "name" => "Krajský svaz ČSOS Vysočina",        "region" => "J" },
    "K11" => { "name" => "Moravskoslezský krajský svaz ČSOS", "region" => "T" },
    "K12" => { "name" => "Olomoucký krajský svaz ČSOS",       "region" => "M" },
    "K13" => { "name" => "Zlínský krajský svaz ČSOS",         "region" => "Z" },
    "K14" => { "name" => "Jihomoravský krajský svaz ČSOS",    "region" => "B" },
  }

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
    data = URI.open(oris_url).read rescue nil
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
    data = URI.open(oris_url).read rescue nil
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
