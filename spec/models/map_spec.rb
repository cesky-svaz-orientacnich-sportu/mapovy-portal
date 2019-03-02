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

require 'rails_helper'

RSpec.describe Map, type: :model do
  
  it "assigns a good first number" do
    map1 = FactoryGirl.create(:map, region: 'A')
    assert_equal '15A001O', map1.identifier_filing
  end
  
  it "assigns properly into a hole and after region change" do
    map1 = FactoryGirl.create(:map, region: 'A')
    map2 = FactoryGirl.create(:map, region: 'A', map_sport: Map::MAP_SPORT_MTBO)
    map3 = FactoryGirl.create(:map, region: 'A')
    assert_equal '15A001O', map1.identifier_filing
    assert_equal '15A002M', map2.identifier_filing
    assert_equal '15A003O', map3.identifier_filing
    
    map2.region = 'H'
    map2.identifier_filing = map2.proposed_identifier_filing
    map2.save
    assert_equal '15H001M', map2.identifier_filing

    map4 = FactoryGirl.create(:map, region: 'A')
    assert_equal '15A002O', map4.identifier_filing
  end
  
end
