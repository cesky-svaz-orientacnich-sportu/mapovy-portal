# -*- encoding : utf-8 -*-
unless Rails.env.development?
  Mapserver::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[Mapserver] ",
      :sender_address => %{"mapserver" <mapovyportal@orientacnisporty.cz>},
      :exception_recipients => %w{david.pustai@gmail.com}
    }

  ExceptionNotifier::Rake.configure
end
