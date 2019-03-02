# -*- encoding : utf-8 -*-
class ClubsDatatable
  delegate :params, :h, :t, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: Club.count,
      recordsFiltered: clubs.total_count,
      data: data
    }
  end

private

  def data
    clubs.map do |club|
      [
        link_to(club.name.blank? ? club.abbreviation : club.name, club, :"data-title" => "#{t('mapserver.listClubContentMap')} #{club.abbreviation}", :"data-toggle" => "tooltip"),
        club.oris_data.empty? ? club.abbreviation : link_to(club.abbreviation, club.oris_link, :target => '_blank', :"data-title" => t('clubs.oris_link'), :"data-toggle" => "tooltip"),
        club.region,
        club.district,
      ]
    end
  end

  def clubs
    @clubs ||= fetch_clubs
  end

  def fetch_clubs
    clubs = if sort_column
      Club.order("#{sort_column} #{sort_direction}")
    else
      Club.where(1)
    end
    clubs = clubs.page(page).per(per_page)
    if params[:search].present? and params[:search][:value].present?
      clubs = clubs.where("name like :search OR abbreviation like :search OR region like :search OR district like :search", search: "%#{params[:search][:value]}%")
    end
    clubs
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[name abbreviation region district]
    columns[params[:order]['0'][:column].to_i]  rescue nil
  end

  def sort_direction
    (params[:order]['0'][:dir]) == "desc" ? "desc" : "asc"
  end
end
