class SessionsController < Devise::SessionsController
  before_action :before_login, :only => :create
  after_action :after_login, :only => :create

  def before_login
  end

  def after_login
    puts "Checking #{current_user} against oris"
    current_user.check_against_oris
    current_user.save
  end
end
