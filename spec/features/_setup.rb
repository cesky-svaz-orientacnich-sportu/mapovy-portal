RSpec.shared_context "shared environment" do
  background do
    @user = FactoryBot.create(:user)
    @organizer = FactoryBot.create(:organizer, authorized_clubs: 'AAA')
    @cartographerA = FactoryBot.create(:cartographer, authorized_regions: 'A')
    @cartographerB = FactoryBot.create(:cartographer, authorized_regions: 'B')
    @manager = FactoryBot.create(:user, role: 'manager')
    @admin = FactoryBot.create(:user, role: 'admin')
    Club.create(abbreviation: 'AAA')
  end
end
