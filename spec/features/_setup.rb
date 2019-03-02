RSpec.shared_context "shared environment" do
  background do
    @user = FactoryGirl.create(:user)
    @organizer = FactoryGirl.create(:organizer, authorized_clubs: 'AAA')
    @cartographerA = FactoryGirl.create(:cartographer, authorized_regions: 'A')
    @cartographerB = FactoryGirl.create(:cartographer, authorized_regions: 'B')
    @manager = FactoryGirl.create(:user, role: 'manager')
    @admin = FactoryGirl.create(:user, role: 'admin')
    Club.create(abbreviation: 'AAA')
  end
end