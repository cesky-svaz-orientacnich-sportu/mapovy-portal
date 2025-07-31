require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mapserver
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Prague"
    config.active_record.default_timezone = :local
    config.beginning_of_week = :monday
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_record.encryption.hash_digest_class = OpenSSL::Digest::SHA256
    config.active_record.encryption.support_sha1_for_non_deterministic_encryption = true

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/datatables)
    config.autoload_lib(ignore: %w(assets tasks))

    # The default locale is :cs and available locales are specified manually.
    config.i18n.available_locales = [:cs, :en]
    config.i18n.default_locale = :cs
    I18n.enforce_available_locales = true

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.action_controller.permit_all_parameters = true
  end
end
