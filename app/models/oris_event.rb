# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: oris_events
#
#  id                :integer          not null, primary key
#  date              :date
#  obpostupy_map_url :string(255)
#  obpostupy_url     :string(255)
#  oris_json         :text
#  oris_timestamp    :datetime
#  place             :string(255)
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  oris_id           :integer
#

class OrisEvent < ApplicationRecord

  scope :in_year, lambda{|y| where("date_part('year', date) = ?", y).order(:date)}
  scope :sorted, ->{ order(:date) }

  def self.years
    OrisEvent.distinct.pluck(Arel.sql("date_part('year', date)")).sort
  end

  def to_s
    to_label
  end

  def to_label
    s = "[#{date}] #{title} / #{organizers * "+"}"
    unless place.blank?
      if place.size < 20
        s << ", #{place}"
      else
        s << ", #{place[0...20]}..."
      end
    end
    s << " ##{oris_id}"
    s
  end

  def self.obpostupy_lookup
    require 'open-uri'
    require 'nokogiri'

    url = "http://www.obpostupy.cz/index.php"
    doc = Nokogiri::HTML(URI.open(url).read)
    if doc and doc.root
      puts "Loaded obpostupy."
      doc.root.css("#obsah > table.zavody tr").each do |row|
        cells = row.css('td')
        if cells.size == 10
          if anchor = cells[9].css('a').first
            link = anchor['href']
            if link and m = link.match(/Zavod\?id=(\d+)$/)
              oris_id = m[1].to_i
              puts "-> oris ID = #{m[1]}"
              url = "http://www.obpostupy.cz" + cells[2].css('a').first['href']
              puts " --> #{url}"
              if e = OrisEvent.where(oris_id: oris_id).first
                e.update_attribute(:obpostupy_url, url)

                s = URI.open(url).read
                if m = s.encode('ASCII-8BIT',invalid: :replace, undef: :replace).match(/imageUrl = '\/gadget\/kartat\/(\d+)\.jpg'/)
                  map_url = "http://www.obpostupy.cz/gadget/kartat/#{m[1]}.jpg"
                  puts " --> #{map_url}"
                  if e = OrisEvent.where(oris_id: oris_id).first
                    e.update_attribute(:obpostupy_map_url, map_url)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def self.fetch(year, only_new = false)
    require 'open-uri'
    json = JSON.parse(URI.open(oris_list_url(year)).read)
    json['Data'].values.each do |ev|
      oris_id, title, date, place = ev['ID'], ev['Name'], ev['Date'], ev['Place']
      print "[%5s] " % oris_id
      if e = OrisEvent.where(:oris_id => oris_id).first
        puts e
        if !only_new
          e.fetch
        end
      else
        e = OrisEvent.new(:oris_id => oris_id)
        e.fetch
        puts e
        puts e.attributes.inspect
        puts e.save.inspect
        puts e.errors.inspect
      end
    end
  end

  def self.oris_list_url(year)
    "https://oris.orientacnisporty.cz/API/?format=json&method=getEventList&all=1&datefrom=#{year}-01-01&dateto=#{year}-12-31"
  end

  def oris_info_url
    "https://oris.orientacnisporty.cz/API/?format=json&method=getEvent&id=#{oris_id}"
  end

  def oris_url
    "https://oris.orientacnisporty.cz/Zavod?id=#{oris_id}"
  end


  def oris_data
    return {} if oris_json.blank?
    @oris_data ||= JSON[oris_json]['Data']
  end

  def organizers
    orgs = ['Org1', 'Org2'].map do |okey|
      oris_data[okey] && !oris_data[okey].empty? && oris_data[okey]['Abbr']
    end.reject{|x| !x}
  end

  def get(key, url)
    data = URI.open(url).read rescue nil
    if data
      json = JSON[data] rescue nil
      if json and json['Status'] == 'OK'
        update_attribute(key, data)
      end
    end
    sleep 1
  end

  def fetch
    return unless oris_id
    puts " -- fetching"
    get(:oris_json, oris_info_url)
    puts " -- org / plc"
    set_oris_properties
    update_attribute :oris_timestamp, Time.now
    puts " -- OK"
  end

  def set_oris_properties
    unless oris_data['Name'].blank?
      update_attribute :title, oris_data['Name']
    end
    unless oris_data['Date'].blank?
      update_attribute :date, oris_data['Date']
    end
    unless oris_data['Place'].blank?
      update_attribute :place, oris_data['Place']
    end
  end

end
