# -*- encoding : utf-8 -*-
class MapController < ApplicationController

  layout 'map'

  def index
    #
  end

  def convergence_calculator
    date = Date.today.strftime("%Y-%m-%d")
    lat, lng = params[:lat], params[:lng]
    require 'open-uri'
    url = "https://geomag.nrcan.gc.ca/calc/mdcal-r-en.php?latitude=#{lat}&longitude=#{lng}&latitude_north=1&longitude_east=1&date=#{date}"
    doc = Nokogiri::HTML(open(url))
    paragraphs = doc.root.css("main p")
    paragraphs.size >= 2 or begin
      render json: {status: 'error', message: "Could not fetch geomag data! Url was [#{url}]."}.to_json
      return
    end

    mag = paragraphs[0].text.split(":").last.strip
    chg = paragraphs[1].text.split(":").last.strip

    m_deg = mag.split[0].to_i
    m_min = mag.split[1].to_f
    m_sgn = (mag.split[2] == 'West') ? -1 : +1
    m_deg *= m_sgn

    c_min = chg.split[0].to_f
    c_sgn = (chg.split[1] == 'West') ? -1 : +1
    c_min *= c_sgn / 60.0

    data = {
      status: 'OK',
      mag: m_deg + m_min / 60.0,
      mag_text: "#{m_deg}&deg; #{m_min}'",
      chg: c_min,
    }

    render json: data.to_json
  end



  def club
    @club = Club.find(params[:id])
  end

  def show
    @map = Map.find(params[:id])
  end

  def author
    @author = Author.find(params[:id])
  end

  def collection
    @map_collection = MapCollection.friendly.find(params[:id])
  end

  def convergence
    @map_title = t("mapserver.convergence.header")
  end

end
