# -*- encoding : utf-8 -*-
Mapserver::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.eager_load = true

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( _*.js _*.css mapserver/locale/*.js)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => "mapy.orientacnisporty.cz" }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :authentication => nil,
    :address  => "127.0.0.1",
    :port  => 25,
    :domain  => "samson.cb.cz",
    :enable_starttls_auto => false
    }

  # table IDs
  config.maps_fusion_table_id = '1FM0klQ2pUQsvB2_o_KmanbL71K9aqpWZH5IRKJnh'
  #config.convergence_fusion_table_id = '1QaD5B-5uaI3XFWH_JGoCDet5MoxPONAfT6qAgVu2'
  config.selected_fusion_table_id = '10Z0IZ5j-GB5K67aK026jGeTU1Jvllv6gUxk5prI4'
  config.blocking_fusion_table_id = '1EBIzS199Q_wcYcJn0Jx6jcmFwtlf3rcaopunP-k8'
  config.embargo_fusion_table_id = '1bHJthBlZp4fenXUHanfVzu3aEB09DBYeBrCsBzxJ'
   # asset host (for JPGs et al)
  config.asset_root_url = "https://mapy.orientacnisporty.cz"

end