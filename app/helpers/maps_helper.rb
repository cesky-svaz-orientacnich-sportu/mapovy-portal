# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: maps
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  patron                    :string(255)
#  patron_accuracy           :string(255)
#  year                      :integer
#  year_accuracy             :string(255)
#  scale                     :integer
#  archive_print1_class      :string(255)
#  archive_print2_class      :string(255)
#  archive_print3_class      :string(255)
#  archive_extra_print_count :integer
#  equidistance              :float
#  identifier_other          :string(255)
#  locality                  :string(255)
#  area_size                 :float
#  issued_by                 :string(255)
#  printed_by                :string(255)
#  map_type                  :string(255)
#  drawing_technique         :string(255)
#  printing_technique        :string(255)
#  resource                  :string(255)
#  main_race_title           :string(255)
#  main_race_date            :date
#  administrator             :text
#  identifier_approval       :string(255)
#  identifier_filing         :string(255)
#  note_public               :text
#  note_internal             :text
#  preview_identifier        :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  created_by_id             :integer
#  map_family                :string(255)
#  map_sport                 :string(255)
#  oris_event_id             :integer
#  non_oris_event_url        :string(255)
#  shape_json                :text
#  shape_kml                 :text
#  georeference              :string(255)
#  region                    :string(255)
#  state                     :string(255)
#  record_log                :text
#  approved_by_id            :integer
#  mapping_state             :string(255)
#  slug                      :string(255)
#  has_jpg                   :boolean          default(FALSE), not null
#  has_kml                   :boolean          default(FALSE), not null
#  administrator_email       :string(255)
#  last_reminder_sent_at     :date
#  state_changed_at          :date
#  completed_by_id           :integer
#  user_updated_at           :datetime
#

module MapsHelper

  def map_attribute_label(key, with_help = true)
    if with_help == :edit
      (
        I18n.translate("mapserver.map_attributes.#{key}") +
        "&nbsp;" +
        icon('question-circle', popover: I18n.translate("mapserver.map_attribute_hints.#{key}", default: I18n.translate("mapserver.map_attribute_descriptions.#{key}")).gsub("\n", "<br />").html_safe, popover_placement: :bottom, popover_trigger: "hover", color: "#9bf")
      ).html_safe
    elsif with_help == :edit_short
      (
        icon('question-circle', popover: I18n.translate("mapserver.map_attribute_hints.#{key}", default: I18n.translate("mapserver.map_attribute_descriptions.#{key}")).gsub("\n", "<br />").html_safe, popover_placement: :bottom, popover_trigger: "hover", color: "#9bf")
      ).html_safe
    elsif with_help
      (
        I18n.translate("mapserver.map_attributes.#{key}") +
        "&nbsp;" +
        icon('question-circle', tooltip: I18n.translate("mapserver.map_attribute_descriptions.#{key}"), color: "#9bf")
      ).html_safe
    else
      I18n.translate("mapserver.map_attributes.#{key}")
    end
  end

  def author_attribute_label(key, with_help = true)
    if with_help == :edit
      (
        I18n.translate("mapserver.author_attributes.#{key}") +
        "&nbsp;" +
        icon('question-circle', tooltip: I18n.translate("mapserver.author_attribute_hints.#{key}", default: I18n.translate("mapserver.author_attribute_descriptions.#{key}")), tooltip_placement: :bottom, color: "#9bf")
      ).html_safe
    elsif with_help == :edit_short
      (
        icon('question-circle', tooltip: I18n.translate("mapserver.author_attribute_hints.#{key}", default: I18n.translate("mapserver.author_attribute_descriptions.#{key}")), tooltip_placement: :bottom, color: "#9bf")
      ).html_safe
    elsif with_help
      (
        I18n.translate("mapserver.author_attributes.#{key}") +
        "&nbsp;" +
        icon('question-circle', tooltip: I18n.translate("mapserver.author_attribute_descriptions.#{key}", default: I18n.translate("mapserver.author_attributes.#{key}")), color: "#9bf")
      ).html_safe
    else
      I18n.translate("mapserver.author_attributes.#{key}")
    end
  end

  def print_identifier_filing(s)
    if s and m = s.match(/(\d\d)([A-Z])(\d\d\d)([A-Z])/)
      [1,2,3,4].map{|x| content_tag(:span, m[x].to_s, class: 'identifier_filing_component')}.join.html_safe
    else
      s
    end
  end

  def print_identifier_filing_for_input_value(s)
    if s and m = s.match(/(\d\d)([A-Z])(\d\d\d)([A-Z])/)
      "#{m[1].to_s} | #{m[2].to_s} | #{m[3].to_s} | #{m[4].to_s}"
    else
      s
    end
  end

  def copy_link(map)
    link_to(icon('copy', tooltip: t('mapserver.copy')), [:copy, map], method: :post, data: {confirm: t("mapserver.copy-confirmation")})
  end

  def map_buttons(map, destroy_redirect_path = nil)
    s = "".html_safe
    if current_user
      if (map.created_by == current_user and [Map::STATE_PROPOSED, Map::STATE_SAVED_WITHOUT_FILING].include?(map.state)) or has_role?(:manager)
        s+= link_to icon('pencil-square-o', tooltip: 'upravit'), [:edit, map]
        s+= " ".html_safe
      end

      if current_user.has_role?(:contributor, :organizer, :cartographer, :manager)
        s+= copy_link(map)
        s+= " ".html_safe
      end

      if (map.created_by == current_user and [Map::STATE_PROPOSED, Map::STATE_SAVED_WITHOUT_FILING].include?(map.state)) or has_role?(:manager)
        s+= link_to icon('times', tooltip: 'zrušit'), [:remove, map], method: :post, data: {confirm: "Opravdu chceš zrušit záznam mapy #{map}?"}
        s+= " ".html_safe
      end
      if admin?
        s+= link_to icon('minus-circle', tooltip: 'smazat'), map_path(map, redirect_to: destroy_redirect_path), method: :delete, data: {confirm: "Opravdu chceš SMAZAT záznam mapy #{map}?"}
        s+= " ".html_safe
      end
      if map.has_jpg?
        s+= link_to(icon('eye', tooltip: t('mapserver.preview')), map.preview_path)
        s+= " ".html_safe
      end
    end
    s += link_to icon('globe', tooltip: 'zobrazit v mapě'), map_in_map_path(map.id)
    s.html_safe
  end

  def list_filter_text(index, var)
    content_tag(:th, map_attribute_label(var, false)) +
    content_tag(:td, style: "white-space:nowrap") do
      select_tag(nil, options_for_select(["~", "=", "!", ">", "<", "0", "*"]), id: "col_#{index}_filter_type", class: 'column_filter', data: {column: index}) +
      text_field_tag(nil, "", id: "col_#{index}_filter", class: 'column_filter', data: {column: index})
    end
  end

  def list_filter_select(index, var, opts)
    content_tag(:th, map_attribute_label(var, false)) +
    content_tag(:td, style: "white-space:nowrap") do
      select_tag(nil, options_for_select(["~", "=", "!", ">", "<", "0", "*"]), id: "col_#{index}_filter_type", class: 'column_filter', data: {column: index}) +
      select_tag(nil, options_for_select([["", nil]] + opts), id: "col_#{index}_filter", class: 'column_filter', data: {column: index})
    end
  end

  def update_oris_event_link(map)
    s = "".html_safe
    if current_user
      if map.created_by == current_user or has_role?(:manager)
        s+= link_to icon('repeat', tooltip: "Aktualizovat data z ORISu"), [:update_oris_data, @map], class: "pull-right"
      end
    end
    s.html_safe
  end

end
