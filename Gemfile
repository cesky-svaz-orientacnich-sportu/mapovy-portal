source "http://rubygems.org"

ruby "2.7.6"

gem 'activerecord-postgis-adapter'
gem "bootsnap", "~> 1.7"
gem "bootstrap-sass"
gem "coffee-rails"
gem "color"
gem "dalli"
gem "devise", "~> 4.8"
gem "dotenv-rails", "~> 2.8" # env vars management
gem "exception_notification"
gem "exception_notification-rake", "~> 0.3.1"
gem "friendly_id"
gem "haml"
gem "jquery-datatables-rails"
gem "jquery-fileupload-rails"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "kaminari"
gem "kaminari-bootstrap"
gem "magic_encoding"
gem "pg", "~> 1.1" # PostgreSQL as the database for Active Record
gem "nested_form"
gem "nilify_blanks"
gem "nokogiri", "~> 1.13" # XML handling
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "paperclip"
gem "paper_trail", "~> 12.3"
gem "rails", "~> 7.0"
gem "rails-controller-testing"
gem "RedCloth"
gem "rgeo", "~> 2.4"
gem "rgeo-geojson"
gem "sass-rails" # SCSS compiling
gem "select2-rails"
gem "sprockets-rails"
gem "to_xls"
gem "turnout"
gem "uuidtools"
gem "webpacker"
gem 'whenever', require: false

gem "rspec-rails", :group => [:test, :development]
gem "factory_bot_rails", :group => [:test, :development]
gem "ci_reporter_rspec"

gem "execjs", :group => [:production, :staging]
gem "terser", :group => [:production, :staging]

group :test do
  gem "database_cleaner"
  gem "guard-rspec"
  gem "launchy"
end

group :development do
  gem "annotate"
  gem "better_errors"
  gem "bcrypt_pbkdf", "~> 1.1", require: false
  gem "binding_of_caller"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-db-tasks", :require => false
  gem 'capistrano-nvm', require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-yarn", require: false
  gem "ed25519", "~> 1.3", require: false
  gem "lorem-ipsum"
  gem "thin"
end
