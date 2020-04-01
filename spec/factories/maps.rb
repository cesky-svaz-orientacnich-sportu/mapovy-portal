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
