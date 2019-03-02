# -*- encoding : utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: "\"Mapový portál ČSOS\" <mapovyportal@orientacnisporty.cz>"

  def new_user(user)
    @user = user
    users = User.where(role: 'admin')
    mail(to: users.map(&:email), subject: "Nový uživatel mapového portálu -- #{@user}") if users.any?
  end
end
