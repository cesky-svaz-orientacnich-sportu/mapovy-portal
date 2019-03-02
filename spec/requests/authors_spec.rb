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
    
    @a1 = FactoryGirl.create(:author)
    @a2 = FactoryGirl.create(:author)
    @a3 = FactoryGirl.create(:author)
    
    @m1 = FactoryGirl.create(:map)
    @m2 = FactoryGirl.create(:map)
    @m3 = FactoryGirl.create(:map)
    
    @m1.authors = [@a1]
    @m2.authors = [@a2,@a3]
    @m3.authors = [@a1,@a3]
    [@a1, @a2, @a3].each(&:save)
    
    @admin = FactoryGirl.create(:user, role: 'admin')
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
