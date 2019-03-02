class SessionsController < Devise::SessionsController
  before_filter :before_login, :only => :create
  after_filter :after_login, :only => :create

  def before_login
  end

  def after_login
    puts "Checking #{current_user} against oris"
    current_user.check_against_oris
    current_user.save
  end
end