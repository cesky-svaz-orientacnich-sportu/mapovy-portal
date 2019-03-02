# -*- encoding : utf-8 -*-
class MapsDatatable
  delegate :params, :t, :link_to, :_map_path, :number_to_currency, :icon, :current_user, :admin?, :has_role?, :copy_link, to: :@view

  def initialize(view, collection)
    @view = view
    @collection = collection
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: @collection.count,
      recordsFiltered: maps.total_count,
      data: data
    }
  end

private

  def data
    maps.map do |map|
      [
        link_to(map, _map_path(map), "data-id" => map.id),
        map.club ? link_to(map.club, map.club) : map.patron,
        (map.year && map.year.to_i > 0 ? map.year : "---"),
        map.scale,
        Map::MAP_SPORTS.include?(map.map_sport) ? t("mapserver.map_enums.map_sport.#{map.map_sport}") : map.map_sport,
        map.locality,
        (map.has_jpg? ? link_to(icon('eye', tooltip: t('mapserver.preview')), map.preview_path, class: 'mapPreviewLink') : icon('eye')) +
        ((has_role?(:manager) or current_user && (current_user == map.created_by)) ? "&nbsp;".html_safe + link_to(icon('edit', tooltip: t('mapserver.edit')), [:edit, map]) : '') +
        ((has_role?(:manager)) ? "&nbsp;".html_safe + copy_link(map) : ''),
        map.id,
        map.archive_
      ]
    end
  end

  def maps
    @maps ||= fetch_maps
  end

  def fetch_maps
    maps = if sort_column
      @collection.order("#{sort_column} #{sort_direction}")
    else
      @collection.sorted
    end
    maps = maps.page(page).per(per_page)
    if params[:search].present? and params[:search][:value].present?
      maps = maps.where("maps.title LIKE :search OR maps.patron LIKE :search OR maps.id = :xsearch", search: "%#{params[:search][:value]}%", xsearch: params[:search][:value])
    end
    maps
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[title patron year scale sport locality]
    columns[params[:order]['0'][:column].to_i] rescue nil
  end

  def sort_direction
    (params[:order]['0'][:dir]) == "desc" ? "desc" : "asc"
  end
end
