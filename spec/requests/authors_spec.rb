# == Schema Information
#
# Table name: authors
#
#  id            :integer          not null, primary key
#  note          :string(255)
#  full_name     :string(255)
#  club          :text
#  activity      :string(255)
#  year_of_birth :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'


RSpec.describe "Authors", type: :request do

  before :example do

    @a1 = FactoryBot.create(:author)
    @a2 = FactoryBot.create(:author)
    @a3 = FactoryBot.create(:author)

    @m1 = FactoryBot.create(:map)
    @m2 = FactoryBot.create(:map)
    @m3 = FactoryBot.create(:map)

    @m1.authors = [@a1]
    @m2.authors = [@a2,@a3]
    @m3.authors = [@a1,@a3]
    [@a1, @a2, @a3].each(&:save)

    @admin = FactoryBot.create(:user, role: 'admin')
    login @admin
  end

  it "can be listed" do
    get authors_path
    expect(response).to have_http_status(200)
    expect(response).to render_template(:index)
  end

  it "can be shown" do
    get author_path(@a1)
    expect(response).to have_http_status(200)
    expect(response).to render_template(:index)
  end

end
