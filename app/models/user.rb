# -*- encoding : utf-8 -*-
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
#  above_role_authorizations :array         default([]), not null
#  authorized_clubs       :string(255)
#  authorized_regions     :string(255)
#  full_name              :string(255)
#

class User < ApplicationRecord
  extend ArrayEnum

  nilify_blanks

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :authorizations

  has_many :created_maps, :class_name => 'Map', :foreign_key => :created_by_id

  before_save :check_against_oris_possibly
  after_create :notify_create

  ROLES = %w{contributor organizer cartographer manager admin}

  array_enum above_role_authorizations: {
    :embargoes => 1
  }

  ABOVE_ROLE_AUTHORIZATIONS = {
    :embargoes => 'správa embarg'
  }

  def name_for_sort
    ary = name.split
    ([ary.last] + ary[0...-1] || []) * " "
  end

  def to_s
    if role == 'cartographer' and regions.any?
      "#{name} [koordinátor pro #{regions.map{|r| Map::REGIONS[r]} * " a "}]"
    elsif !role.blank?
      "#{name} [#{role_to_s}]"
    elsif oris_registrations.blank?
      "#{name}"
    else
      "#{name} [#{oris_registrations}]"
    end
  end

  def to_log
    "#{name} (ID##{id} / #{role_to_s})"
  end

  def role_to_s
    (!role.blank?) ? I18n.t("roles.#{role}") : '---'
  end

  def above_role_authorizations_to_s
    (!above_role_authorizations.blank?) ? above_role_authorizations.map {|k, v| ABOVE_ROLE_AUTHORIZATIONS[k.to_sym]}.join(', ') : '---'
  end

  def check_against_oris_possibly
    if email_changed? or new_record?
      check_against_oris
    end
  end

  def has_role?(*roles)
    return true if self.role == 'admin'
    roles.map(&:to_s).include?(self.role.to_s)
  end

  def name
    full_name || authorizations.map(&:name).reject(&:blank?).first || email || '---'
  end

  def admin?
    has_role?(:admin)
  end

  def check_against_oris
    base = "https://oris.orientacnisporty.cz/API"
    firstname, lastname = *name.split
    par = {:method => 'getRegNum', :format => 'json', :firstname => firstname, :lastname => lastname, :email => email}
    log = []
    log << "Request: #{par.inspect} -> #{base}"
    require 'net/http'
    response = Net::HTTP.get_response(URI(base + "?" + par.to_query))
    log << "Reply: #{response.body}"
    results = JSON[response.body]['Data']
    if results.empty?
      log << "No match found."
    else
      regs = []
      clubs = []
      results.values.each do |r|
        regs << r['RegNum']
        log << "Found registration #{r['RegNum']}"
        if r['ClubRoles'] and r['ClubRoles']['Role_5'] and r['ClubRoles']['Role_5']['HasRole']
          clubs << r['RegNum'][0...3]
          log << "Has the [map] role for #{r['RegNum'][0...3]}"
        else
          log << "Does not have the [map] role for #{r['RegNum'][0...3]}"
        end
      end
      self.oris_registrations = regs * " "
      self.authorized_clubs = clubs * " "
      if clubs.any? and !has_role?(:organizer,:cartographer,:manager)
        self.role = 'organizer'
      end
      if self.role.blank?
        self.role = 'contributor'
        self.authorized_clubs = nil
      end
      log << "Registrations = #{regs}"
      log << "Clubs = #{clubs}"
    end
    log
  end

  def regions
    (authorized_regions || "").strip.split
  end

  def clubs
    (authorized_clubs || "").strip.split
  end

  def patrons
    priv = (has_role?(:cartographer,:manager) ? Club.where(is_public: false) : Club.where(abbreviation: clubs))
    pub = Club::PUBLIC_CLUBS.reject{|k,p| !has_public_club_permission?(p)}.map{|k,p| Club.where(:abbreviation => k).first}
    (pub + priv).sort{|a,b| a.abbreviation <=> b.abbreviation}
  end

  def has_public_club_permission?(patron)
    has_role?(:manager) or (patron.key?("region") and has_role?(:cartographer) and regions.include?(patron["region"]))
  end

  def authorized_to_view_removed_map?
    return admin?
  end

  def to_json
    {
      id: id,
      name: name,
      role: role,
    }.to_json
  end

  def notify_create
    UserMailer.new_user(self).deliver
  end

end
