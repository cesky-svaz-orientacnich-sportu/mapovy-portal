# -*- encoding : utf-8 -*-
class AuthorsDatatable
  delegate :params, :h, :link_to, :number_to_currency, :has_role?, :icon, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: Author.count,
      recordsFiltered: authors.total_count,
      data: data
    }
  end

private

  def data
    authors.map do |author|
      [
        link_to(author.full_name, author),
        (author.year_of_birth.to_i > 0 ? author.year_of_birth : ""),
        author.activity,
        author.club,
        has_role?(:manager) ? ( link_to(icon('edit', tooltip: 'upravit'), [:edit, author]) + (author.cartographers.exists? ? "" : link_to(icon('times', tooltip: 'smazat'), author, method: :delete, data: {confirm: "Opravdu chceš smazat záznam autora #{author}?"}))) : ""
      ]
    end
  end

  def authors
    @authors ||= fetch_authors
  end

  def fetch_authors
    authors = Author.order("#{sort_column} #{sort_direction}").page(page).per(per_page)
    if params[:search].present? and params[:search][:value].present?
      authors = authors.where("LOWER(full_name) LIKE LOWER(:search) OR LOWER(note) LIKE LOWER(:search)", search: "%#{params[:search][:value]}%")
    end
    authors
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[full_name year_of_birth]
    params.key?(:order) ? columns[params[:order]['0'][:column].to_i] || "id" : "id"
  end

  def sort_direction
    params.key?(:order) && (params[:order]['0'][:dir]) == "desc" ? "desc" : "asc"
  end
end
