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

require 'rails_helper'

RSpec.describe Map, type: :model do

  it "assigns a good first number" do
    map1 = FactoryBot.create(:map, region: 'A')
    assert_equal '15A001O', map1.identifier_filing
  end

  it "assigns properly into a hole and after region change" do
    map1 = FactoryBot.create(:map, region: 'A')
    map2 = FactoryBot.create(:map, region: 'A', map_sport: Map::MAP_SPORT_MTBO)
    map3 = FactoryBot.create(:map, region: 'A')
    assert_equal '15A001O', map1.identifier_filing
    assert_equal '15A002M', map2.identifier_filing
    assert_equal '15A003O', map3.identifier_filing

    map2.region = 'H'
    map2.identifier_filing = map2.proposed_identifier_filing
    map2.save
    assert_equal '15H001M', map2.identifier_filing

    map4 = FactoryBot.create(:map, region: 'A')
    assert_equal '15A002O', map4.identifier_filing
  end

end
