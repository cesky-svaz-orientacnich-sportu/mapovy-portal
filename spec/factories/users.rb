# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  oris_registrations     :string(255)
#  role                   :string(255)
#  authorized_clubs       :string(255)
#  authorized_regions     :string(255)
#  full_name              :string(255)
#

FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@mapserver.xxx"}
    sequence(:password) {|n| "secret#{n}"}
    sequence(:full_name) {|n| "Some user #{n}"}
    confirmed_at { 1.day.ago }
    after(:create) do |u|
      u.stub(:check_against_oris) { true }
    end

    factory :contributor do
      role { 'contributor' }
      sequence(:full_name) {|n| "Contributor #{n}"}
      sequence(:email) {|n| "contributor#{n}@mapserver.xxx"}
    end
    factory :organizer do
      role { 'organizer' }
      sequence(:full_name) {|n| "Organizer for #{authorized_clubs} #{n}"}
      sequence(:email) {|n| "organizer#{n}@mapserver.xxx"}
    end
    factory :cartographer do
      role { 'cartographer' }
      sequence(:full_name) {|n| "Cartographer for #{authorized_regions} #{n}"}
      sequence(:email) {|n| "cartographer#{n}@mapserver.xxx"}
    end
  end
end
