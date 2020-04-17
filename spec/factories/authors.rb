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

FactoryBot.define do
  factory :author do
    sequence(:full_name) {|n| "Author #{n}"}
    year_of_birth{ 1950 + rand(40) }
  end
end
