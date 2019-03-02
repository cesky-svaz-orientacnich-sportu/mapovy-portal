# -*- encoding : utf-8 -*-

require 'rails_helper'
require_relative './_setup'

RSpec.feature "Map registration:", type: :feature do
  
  include_context "shared environment"
  
  scenario "organizer submits a map and validation guards him" do
    login_as @organizer, scope: :user
    visit register_maps_path
    
    assert_equal 'AAA', find("#map_patron", :visible => false).value
    
    within '#map_form' do
      fill_in 'map_title', with: 'Žabochy'
      select 'A', from: 'map_region'
      select I18n.t("mapserver.map_enums.map_sport.#{Map::MAP_SPORT_FOOT}"), from: 'map_map_sport'
      select I18n.t("mapserver.map_enums.map_type.isom"), from: 'map_map_type'
      select '(', from: 'map_oris_event_id'
    end
    submit_form('map_form')

    within('h1') { expect(page).to have_content "Ohlásit" }      

    within '#map_form' do
      fill_in 'map_scale', with: '10000'
      fill_in 'map_equidistance', with: '5'
    end
    submit_form('map_form')

    within 'h1' do
      expect(page).to have_content "Mapa Žabochy"
    end

    map = Map.last
    assert_equal polymorphic_path(map), current_path
    assert_equal map.state, Map::STATE_PROPOSED
  end
  
  scenario "organizer submits a map and cartographer accepts it" do
        
    as_user @organizer do
      register_map
      assert_equal Map.last.state, Map::STATE_PROPOSED
    end
    
    map = Map.last
    
    as_user @cartographerA do
      visit map_path(map)
      within 'h1' do
        expect(page).to have_content "Mapa Žabochy"
      end
    
      expect(page).to have_css "#authorize_proposal_form"    
      submit_form("authorize_proposal_form")
    
      assert_equal map.reload.state, Map::STATE_APPROVED
    end
        
  end
  
  scenario "organizer submits a map. cartographer returns, organizer returns again and cartographer should see it" do
    as_user @organizer do
      register_map
      assert_equal Map.last.state, Map::STATE_PROPOSED
    end
    
    map = Map.last
    identifier = map.identifier_filing
    
    as_user @cartographerA do
      visit map_path(map)
      within('h1') { expect(page).to have_content "Mapa Žabochy" }
      expect(page).to have_css "#reject_proposal_form"    
      submit_form("reject_proposal_form")    
      assert_equal Map::STATE_CHANGE_REQUESTED, map.reload.state
      assert_equal identifier, map.identifier_filing
    end
    
    as_user @organizer do
      visit map_path(map)
      expect(page).to have_css "#re_register_map_form"
      submit_form('re_register_map_form')
      within('h1') { expect(page).to have_content "Doplnit ohlášení připravované mapy Žabochy" }    
      submit_form("map_form")          
      within('h1') { expect(page).to have_content "Mapa Žabochy" }    
      assert_equal Map::STATE_PROPOSED, map.reload.state
      assert_equal identifier, map.identifier_filing
    end
    
    as_user @cartographerA do
      visit map_path(map)
      within('h1') { expect(page).to have_content "Mapa Žabochy" }    
      expect(page).to have_css "#authorize_proposal_form"    
      submit_form("authorize_proposal_form")    
      assert_equal Map::STATE_APPROVED, map.reload.state
      assert_equal identifier, map.identifier_filing
    end
    
  end
  
  scenario "organizer submits a map and cartographer rejects it" do
        
    as_user @organizer do
      register_map
      assert_equal Map.last.state, Map::STATE_PROPOSED
    end
    
    map = Map.last

    as_user @cartographerB do
      visit map_path(map)
      within 'h1' do
        expect(page).to have_content "Mapa Žabochy"
      end
    
      expect(page).to have_no_css "#reject_proposal_form"    
    end
    
    as_user @cartographerA do
      visit map_path(map)
      within 'h1' do
        expect(page).to have_content "Mapa Žabochy"
      end
    
      expect(page).to have_css "#reject_proposal_form"    
      within '#reject_proposal_form' do
        fill_in 'map_comment', with: 'Vracím ti to.'
      end
      submit_form("reject_proposal_form")
    
      map = map.reload
      assert_equal map.state, Map::STATE_CHANGE_REQUESTED
      assert map.record_log.include? "Vracím ti to."
    end
        
    as_user @organizer do
      visit register_maps_path(map: {id: map.id})
      select 'B', from: 'map_region'
      submit_form("map_form")
    end
    
    as_user @cartographerA do
      visit map_path(map)
      within 'h1' do
        expect(page).to have_content "Mapa Žabochy"
      end
    
      expect(page).to have_no_css "#reject_proposal_form"    
    end
    
  end
  
end


def register_map
  visit register_maps_path

  within '#map_form' do
    fill_in 'map_title', with: 'Žabochy'
    select 'A', from: 'map_region'
    select I18n.t("mapserver.map_enums.map_sport.#{Map::MAP_SPORT_FOOT}"), from: 'map_map_sport'
    select I18n.t("mapserver.map_enums.map_type.isom"), from: 'map_map_type'
    select '(', from: 'map_oris_event_id'
    fill_in 'map_scale', with: '10000'
    fill_in 'map_equidistance', with: '5'
  end
  submit_form('map_form')

  within 'h1' do
    expect(page).to have_content "Mapa Žabochy"
  end
end