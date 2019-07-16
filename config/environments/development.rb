# -*- encoding : utf-8 -*-
Mapserver::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.eager_load = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.assets.cache_store = :null_store  # Disables the Asset cache
  config.sass.cache = false  # Disable the SASS compiler cache
  
  # table IDs 
  config.maps_fusion_table_id = "1GmFqj5L4ElYP7krl_lwuPgOcrPhtmAek5eC8lKRB"
  #config.convergence_fusion_table_id = '1QaD5B-5uaI3XFWH_JGoCDet5MoxPONAfT6qAgVu2'
  config.selected_fusion_table_id = '10Z0IZ5j-GB5K67aK026jGeTU1Jvllv6gUxk5prI4'
  config.blocking_fusion_table_id = '1EBIzS199Q_wcYcJn0Jx6jcmFwtlf3rcaopunP-k8'
  config.embargo_fusion_table_id = '1bHJthBlZp4fenXUHanfVzu3aEB09DBYeBrCsBzxJ'
  # asset host (for JPGs et al)
  config.asset_root_url = "http://mapy.orientacnisporty.cz"

  config.action_mailer.default_url_options = { :host => "localhost:3333" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }   
end