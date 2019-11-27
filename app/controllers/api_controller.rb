# -*- encoding : utf-8 -*-
class ApiController < ApplicationController
  
  def list
    maps = Map.where(state: %w{archived completed approved finalized}).map do |m| 
      {
          id: m.id, 
          title: m.title, 
          url: url_for(m),
          club: m.club && m.club.abbreviation,
          scale: m.scale_,
          sport: m.map_sport_,
          year: m.year,
          region: m.region_,
          locality: m.locality,
      }
    end
    respond_to do |format|
      format.json do
        render json: {status: 'success', data: maps}.to_json
      end
    end
  end

  def oris
    oris_maps = Map.where(state: %w{archived completed approved finalized}).where('oris_event_id IS NOT NULL').inject({}){|h,m| h[m.oris_event.oris_id] ||= []; h[m.oris_event.oris_id] << {id: m.id, title: m.title, url: url_for(m)}; h}
    respond_to do |format|
      format.json do
        render json: {status: 'success', data: oris_maps}.to_json
      end
    end
  end

  def oris_by_id
    maps = Map.where(state: %w{archived completed approved finalized}).joins(:oris_event).where(oris_events: {oris_id: params[:id]})
    respond_to do |format|
      format.json do
        if maps.any?
          render json: {status: 'success', data: maps.map{|map| {id: map.id, title: map.title, url: url_for(map)}}}.to_json
        else
          render json: {status: 'error', message: "no map found for oris_event_id = #{params[:id]}"}.to_json
        end
      end
    end
  end

  def maps_in_point
    lon = URI.decode(request.query_parameters['lonlat']).split(',').first
    lat = URI.decode(request.query_parameters['lonlat']).split(',').last
    layers = URI.decode(request.query_parameters['layers']).split(',')

    # pořadí zjišťování je důležité, mělo by inverzně odpovídat pořadí WMS vrstvech v nastavení Mapserveru
    if layers.include? 'blocking'
      m = Map
            .where("St_Intersects(shape_geom, St_MakeEnvelope(#{lon.to_f - 0.000001},#{lat.to_f - 0.000001},#{lon.to_f + 0.000001},#{lat.to_f + 0.000001}))")
            .where(URI.decode(request.query_parameters['whereB']))
            .order(year: :desc).first
    end
    if not m.present? and layers.include? 'embargoes'
      m = Map
            .where("St_Intersects(shape_geom, St_MakeEnvelope(#{lon.to_f - 0.000001},#{lat.to_f - 0.000001},#{lon.to_f + 0.000001},#{lat.to_f + 0.000001}))")
            .where(URI.decode(request.query_parameters['whereE']))
            .order(year: :desc).first
    end
    if not m.present? and layers.include? 'maps2'
      m = Map
            .where("St_Intersects(shape_geom, St_MakeEnvelope(#{lon.to_f - 0.000001},#{lat.to_f - 0.000001},#{lon.to_f + 0.000001},#{lat.to_f + 0.000001}))")
            .where(URI.decode(request.query_parameters['where2']))
            .order(year: :desc).first
    end
    if not m.present? and layers.include? 'maps'
      m = Map
            .where("St_Intersects(shape_geom, St_MakeEnvelope(#{lon.to_f - 0.000001},#{lat.to_f - 0.000001},#{lon.to_f + 0.000001},#{lat.to_f + 0.000001}))")
            .where(URI.decode(request.query_parameters['where']))
            .order(year: :desc).first
    end

    respond_to do |format|
      format.json do
        if m.present?
          render json: {status: 'success', data: {
            id: m.id, 
            title: m.title,
            patron: m.patron,
            year: m.year,
            state: m.state_,
            scale: m.scale_,
            map_sport: m.map_sport_,
            map_family: m.map_family_,
            has_jpg: m.has_jpg,
            preview_identifier: m.preview_identifier,
            #has_blocking
            #has_embargo
            #blocking_from,
            #blocking_until,
            #embargo_until,
          }}.to_json
        else
          render json: {status: 'error', message: "no map found in point = #{params[:lonlat]}"}.to_json
        end
      end
    end
  end

  def select
    sql = "SELECT #{request.query_parameters['select'].join(',')} FROM maps"
    sql += request.query_parameters.has_key?('where') ? " WHERE #{request.query_parameters['where']}" : ""
    sql += request.query_parameters.has_key?('group_by') ? " GROUP BY #{request.query_parameters['group_by']}" : ""
    sql += request.query_parameters.has_key?('order_by') ? " ORDER BY #{request.query_parameters['order_by']}" : ""
    maps = Map.find_by_sql(sql)
    respond_to do |format|
      format.json do
        render json: {status: 'success', data: maps}.to_json
      end
    end
  end

end
