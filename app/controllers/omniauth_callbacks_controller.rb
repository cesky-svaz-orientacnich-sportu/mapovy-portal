# -*- encoding : utf-8 -*-
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  require 'uuidtools'

  def facebook
    oauthorize "Facebook"
  end

  def google
    oauthorize "Google"
  end

  def google_oauth2
    oauthorize "Google"
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

private

  def oauthorize(kind)
    @user = find_for_ouath(kind, request.env["omniauth.auth"], current_user)
    if @user
      @user.update_attribute :confirmed_at, Time.now
      @user.update_attribute :confirmation_sent_at, Time.now
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      session["devise.#{kind.downcase}_data"] = request.env["omniauth.auth"]
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def find_for_ouath(provider, access_token, resource=nil)
    user, email, name, uid, auth_attr = nil, nil, nil, {}
    case provider
    when "Facebook"
      puts "Facebook access token : #{access_token.inspect}"
      puts "Facebook extra : #{access_token['extra'].inspect}"
      uid = access_token['uid']
      email = access_token['extra']['raw_info']['email']
      auth_attr = { :uid => uid, :token => access_token['credentials']['token'], :secret => nil, :name => access_token['extra']['raw_info']['name'], :link => access_token['extra']['link'] }
    when "Google"
      puts "Google access token : #{access_token.inspect}"
      uid = access_token['uid']
      email = access_token['info']['email']
      auth_attr = { :uid => uid, :token => access_token['credentials']['token'], :secret => nil, :name => access_token['info']['name'] }
    else
      raise "Provider #{provider} not handled"
    end
    if resource.nil?
      puts "No resource! Email = #{email}, name = #{name}"
      if email
        user = find_for_oauth_by_email(email, resource)
      elsif uid && name
        user = find_for_oauth_by_uid(uid, resource)
        if user.nil?
          user = find_for_oauth_by_name(name, resource)
        end
      end
      puts "No resource, but user = #{user.inspect}"
    else
      user = resource
    end

    auth = user.authorizations.find_by_provider(provider)
    if auth.nil?
      auth = user.authorizations.build(:provider => provider)
      user.authorizations << auth
    end
    auth.update auth_attr

    if user and user.full_name.blank?
      user.update_attribute :full_name, user.authorizations.map(&:name).reject(&:blank?).first
    end

    return user
  end

  def find_for_oauth_by_uid(uid, resource=nil)
    user = nil
    if auth = Authorization.find_by_uid(uid.to_s)
      user = auth.user
    end
    return user
  end

  def find_for_oauth_by_email(email, resource=nil)
    if user = User.find_by_email(email)
      user
    else
      user = User.new(:email => email, :password => Devise.friendly_token[0,20], :confirmed_at => Time.now, :confirmation_sent_at => Time.now)
      user.save
      puts "Created new user by email!"
    end
    return user
  end

  def find_for_oauth_by_name(name, resource=nil)
    if user = User.find_by_name(name)
      user
    else
      user = User.new(:name => name, :password => Devise.friendly_token[0,20], :email => "#{UUIDTools::UUID.random_create}@host", :confirmed_at => Time.now, :confirmation_sent_at => Time.now)
      user.save false
    end
    return user
  end

end
