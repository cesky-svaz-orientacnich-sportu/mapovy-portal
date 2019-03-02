require 'rails_helper'


RSpec.describe "Map registration", type: :request do
  
  before :example do
    @user = FactoryGirl.create(:user)
    @organizer = FactoryGirl.create(:organizer, authorized_clubs: 'AAA')
    @cartographerA = FactoryGirl.create(:cartographer, authorized_regions: 'A')
    @cartographerB = FactoryGirl.create(:cartographer, authorized_regions: 'B')
    @admin = FactoryGirl.create(:user, role: 'admin')
  end
    
  it "can be requested by organizer" do
    login @organizer    
    get register_maps_path
    expect(response).to have_http_status(200)
    expect(response).to render_template(:register)
  end

  it "returns errors when not filled in" do
    login @organizer    
    post register_maps_path    
    expect(response).to have_http_status(200)
    expect(response).to render_template(:register)
    expect(response.body).to match 'map_errors'    
  end
    
  it "can be actually created" do
    login @organizer    
    post register_maps_path, map: FactoryGirl.attributes_for(:map, region: 'A')
    map = assigns(:map)
    expect(response).to redirect_to(map)
    follow_redirect!
    expect(response).to render_template(:show)
    assert_equal Map::STATE_PROPOSED, map.state
  end

  it "can be re-registered and region changes" do
    map0 = FactoryGirl.create(:map, region: 'A')
    login @organizer  
    post register_maps_path, map: {id: map0.id, region: 'B'}
    map = assigns(:map)
    assert_equal map0.id, map.id
    expect(response).to redirect_to(map)
    follow_redirect!
    expect(response).to render_template(:show)
    assert_equal Map::STATE_PROPOSED, map.state
    assert_equal '15B001O', map.identifier_filing
  end
    
  it "can be re-registered and sport changes" do
    map0 = FactoryGirl.create(:map, region: 'A')
    login @organizer  
    post register_maps_path, map: {id: map0.id, map_sport: Map::MAP_SPORT_MTBO}
    map = assigns(:map)
    assert_equal map0.id, map.id
    expect(response).to redirect_to(map)
    follow_redirect!
    expect(response).to render_template(:show)
    assert_equal Map::STATE_PROPOSED, map.state
    assert_equal '15A001M', map.identifier_filing
  end
    
end
