# -*- encoding : utf-8 -*-
class MapsListDatatable
  delegate :params, :h, :t, :link_to, :number_to_currency, :icon, :current_user, :admin?, :has_role?, :map_buttons, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: Map.count,
      recordsFiltered: maps.total_count,
      data: data
    }
  end

private

  def data
    maps.map do |map|
      {
       "id"                  => map.id,
       "state"               => map.state_,
       "title"               => map.title,
       "patron"              => map.patron,
       "patron_accuracy"     => map.patron_accuracy_,
       "year"                => map.year,
       "year_accuracy"       => map.year_accuracy_,
       "scale"               => map.scale_,
       "equidistance"        => map.equidistance_,
       "map_sport"           => map.map_sport_,
       "map_type"            => map.map_type_,
       "map_family"          => map.map_family_,
       "region"              => map.region_,
       "locality"            => map.locality,
       "area_size"           => map.area_size,
       "resource"            => map.resource,
       "georeference"        => map.georeference,
       "mapping_state"       => map.mapping_state,
       "drawing_technique"   => map.drawing_technique_,
       "printing_technique"  => map.printing_technique_,
       "issued_by"           => map.issued_by,
       "printed_by"          => map.printed_by,
       "administrator"       => map.administrator,
       "identifier_filing"   => map.identifier_filing,
       "identifier_approval" => map.identifier_approval,
       "identifier_other"    => map.identifier_other,
       "archive"             => map.archive_,
       "note_public"         => map.note_public,
       "note_internal"       => map.note_internal,
       "created_by"          => map.created_by ? map.created_by.to_s : '',
       "approved_by"         => map.approved_by ? map.approved_by.to_s : '',
       "oris_event"          => map.oris_event ? map.oris_event.to_s : '',
       "main_race_title"     => map.main_race_title,
       "main_race_date"      => map.main_race_date,
       "non_oris_event_url"  => map.non_oris_event_url,
       "is_educational"      => map.is_educational_,
       "blocking_until"      => map.blocking_until,
       "blocking_reason"     => map.blocking_reason,
       "buttons"             => map_buttons(map),
     }
    end
  end

  def maps
    @maps ||= fetch_maps
  end

  def fetch_maps
    maps = if sort_columns.any?
      Map.visible.order(sort_columns.map{|x| x * " "} * ", ")
    else
      Map.visible.sorted
    end
    maps = maps.page(page).per(per_page)
    params[:columns].each do |ci, cdata|
      next unless columns[ci.to_i]
      search = cdata[:search] && cdata[:search][:value]
      unless search.blank?
        t = search[0..0]
        x = search[1..-1]
        case t
        when "0"
          maps = maps.where("#{columns[ci.to_i]} IS NULL OR #{columns[ci.to_i]} = ''")
        when "*"
          maps = maps.where("#{columns[ci.to_i]} IS NOT NULL AND #{columns[ci.to_i]} <> ''")
        when "="
          unless column_is_numeric(columns[ci.to_i]) and x.blank?
            maps = maps.where("#{columns[ci.to_i]} = :search", search: x)
          end
        when ">"
          unless column_is_numeric(columns[ci.to_i]) and x.blank?
            maps = maps.where("#{columns[ci.to_i]} > :search", search: x)
          end
        when "<"
          unless column_is_numeric(columns[ci.to_i]) and x.blank?
            maps = maps.where("#{columns[ci.to_i]} < :search", search: x)
          end
        when "!="
          maps = maps.where("#{columns[ci.to_i]} <> :search", search: x)
        when "~"
          unless column_is_numeric(columns[ci.to_i])
            maps = maps.where("LOWER(#{columns[ci.to_i]}) LIKE LOWER(:search)", search: "%#{x}%")
          end
        end
      end
    end
    maps
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_columns
    cols = []
    return [] if params["order"] == {"0"=>{"column"=>"0", "dir"=>"asc"}}
    params[:order].keys.each do |sk|
      col = params[:columns][params[:order][sk][:column]][:data]
      col = col[0...-1] if col[-1..-1] == "_"
      dir = (params[:order][sk][:dir]) == "desc" ? "desc" : "asc"
      cols << [col, dir]
    end
    cols
  end

  def columns
    %w[id state title patron patron_accuracy year year_accuracy scale equidistance map_sport map_type map_family region locality area_size resource georeference mapping_state drawing_technique printing_technique issued_by printed_by administrator identifier_filing identifier_approval identifier_other archive_ note_public note_internal created_by_id approved_by_id oris_event_id main_race_title main_race_date non_oris_event_url is_educational blocking_until blocking_reason]
  end

  def column_is_numeric(column)
    [:integer, :float, :decimal].include? Map.columns_hash[column].type
  end

end
