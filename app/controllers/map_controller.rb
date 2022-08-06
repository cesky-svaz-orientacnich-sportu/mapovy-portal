# -*- encoding : utf-8 -*-
class MapController < ApplicationController

  layout 'map'

  def index
    #
  end

  def convergence_calculator
    lat, lng = params[:lat], params[:lng]
    require 'open-uri'
    url = "https://www.ngdc.noaa.gov/geomag-web/calculators/calculateDeclination?browserRequest=true&magneticComponent=d&lat1=#{lat}&lat1Hemisphere=N&lon1=#{lng}&lon1Hemisphere=E&model=IGRF&startYear=#{Date.today.strftime("%Y")}&startMonth=#{Date.today.strftime("%-m")}&startDay=#{Date.today.strftime("%-d")}&resultFormat=json"
    json = JSON.load(open(url))

    declination = json['result'][0]['declination'].to_f
    declination_deg = declination.to_i
    declination_min = ((declination - declination_deg) * 60).to_i

    declination_change = json['result'][0]['declnation_sv'].to_f

    data = {
      status: 'OK',
      model: json['model'],
      mag: declination,
      mag_text: "#{declination_deg}° #{declination_min}'",
      chg: declination_change
    }

    render json: data.to_json
  end

  def club
    @club = Club.find(params[:id])
    @map_title = "#{t('mapserver.listClubContentMap')} #{@club}"
  end

  def show
    @map = Map.find(params[:id])
    @map_title = @map.title
  end

  def author
    @author = Author.find(params[:id])
    @map_title = "#{t('mapserver.listAuthContentMap')} #{@author}"
  end

  def collection
    @map_collection = MapCollection.friendly.find(params[:id])
    @map_title = @map_collection.title
  end

  def convergence
    @map_title = t("mapserver.convergence.header")
    @is_convergence = true
  end

end
