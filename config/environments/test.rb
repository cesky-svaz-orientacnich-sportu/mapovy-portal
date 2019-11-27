# -*- encoding : utf-8 -*-
Mapserver::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # table IDs
  config.maps_fusion_table_id = '1fQnFWBaosCEdW-6-CJdaxgO6QjobswIz6Wxk-55N'
  #config.convergence_fusion_table_id = '1QaD5B-5uaI3XFWH_JGoCDet5MoxPONAfT6qAgVu2'
  config.blocking_fusion_table_id = '1EBIzS199Q_wcYcJn0Jx6jcmFwtlf3rcaopunP-k8'
  config.embargo_fusion_table_id = '1bHJthBlZp4fenXUHanfVzu3aEB09DBYeBrCsBzxJ'
  # asset host (for JPGs et al)
  config.asset_root_url = "https://mapy.orientacnisporty.cz"

  # local mailcatcher
  config.action_mailer.default_url_options = { :host => "localhost:3333" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
end
