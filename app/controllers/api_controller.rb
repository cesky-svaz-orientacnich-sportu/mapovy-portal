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

end
