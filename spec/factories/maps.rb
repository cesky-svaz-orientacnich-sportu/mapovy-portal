# == Schema Information
#
# Table name: maps
#
#  id                        :integer          not null, primary key
#  administrator             :text
#  administrator_email       :string(255)
#  archive_extra_print_count :integer
#  archive_print1_class      :string(255)
#  archive_print2_class      :string(255)
#  archive_print3_class      :string(255)
#  area_size                 :float
#  blocking_from             :integer
#  blocking_reason           :text
#  blocking_until            :integer
#  cartographers_for_api     :string(255)
#  color                     :string(255)
#  competition_area_until    :date
#  drawing_technique         :string(255)
#  embargo_until             :date
#  equidistance              :float
#  georeference              :string(255)
#  has_blocking              :boolean          default(FALSE), not null
#  has_competition_area      :boolean          default(FALSE), not null
#  has_embargo               :boolean          default(FALSE), not null
#  has_jpg                   :boolean          default(FALSE), not null
#  has_kml                   :boolean          default(FALSE), not null
#  identifier_approval       :string(255)
#  identifier_filing         :string(255)
#  identifier_other          :string(255)
#  is_educational            :boolean          default(FALSE), not null
#  issued_by                 :string(255)
#  last_reminder_sent_at     :date
#  locality                  :string(255)
#  main_race_date            :date
#  main_race_title           :string(255)
#  map_family                :string(255)
#  map_sport                 :string(255)
#  map_type                  :string(255)
#  mapping_state             :string(255)
#  non_oris_event_url        :string(255)
#  note_internal             :text
#  note_public               :text
#  patron                    :string(255)
#  patron_accuracy           :string(255)
#  preview_identifier        :string(255)
#  printed_by                :string(255)
#  printing_technique        :string(255)
#  record_log                :text
#  region                    :string(255)
#  resource                  :string(255)
#  scale                     :integer
#  shape_geom                :geometry         geometry, 0
#  shape_json                :text
#  shape_kml                 :text
#  slug                      :string(255)
#  state                     :string(255)
#  state_changed_at          :date
#  stroke_color              :string(255)
#  title                     :string(255)
#  user_updated_at           :datetime
#  year                      :integer
#  year_accuracy             :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  approved_by_id            :integer
#  completed_by_id           :integer
#  created_by_id             :integer
#  oris_event_id             :integer
#
# Indexes
#
#  index_maps_on_slug  (slug) UNIQUE
#

FactoryBot.define do
  factory :map do
    sequence(:title) {|n| "Mapa ##{n}"}
    region { 'X' }
    year { 2015 }
    scale { 10000 }
    equidistance { 5 }
    map_type { 'isom' }
    oris_event_id { 0 }
    patron { 'AAA' }
    patron_accuracy { 'imprint' }
    year_accuracy { 'imprint' }
    state { Map::STATE_PROPOSED }
    map_sport { Map::MAP_SPORT_FOOT }
    map_family { Map::MAP_FAMILY_MAP }
    locality {"prostor mapy #{title} v kraji #{region} vydane klubem #{patron}"}
    after(:create) do |map|
      map.update_attribute :identifier_filing, map.proposed_identifier_filing
    end
  end
end
