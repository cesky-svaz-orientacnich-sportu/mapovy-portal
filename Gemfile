source "http://rubygems.org"

ruby "2.7.6"

gem 'activerecord-postgis-adapter'
gem "autoprefixer-rails", "~> 10.4" # vendor prefixin CSS
gem "bootsnap", "~> 1.7"
gem "bootstrap-sass", "~> 3.4"
gem "ci_reporter_rspec", "~> 1.0"
gem "coffee-rails", "~> 5.0"
gem "color", "~> 1.8"
gem "dalli", "~> 3.2"
gem "devise", "~> 4.8"
gem "dotenv-rails", "~> 2.8" # env vars management
gem "exception_notification", "~> 4.5"
gem "exception_notification-rake", "~> 0.3"
gem "friendly_id", "~> 5.4"
gem "haml", "~> 6.0"
gem "jquery-datatables-rails", "~> 3.4"
gem "jquery-fileupload-rails", "~> 1.0"
gem "jquery-rails", "~> 4.5"
gem "jquery-ui-rails", "~> 6.0"
gem "kaminari", "~> 1.2"
gem "kaminari-bootstrap", "~> 3.0"
gem "magic_encoding", "~> 0.0.2"
gem "pg", "~> 1.1" # PostgreSQL as the database for Active Record
gem "nested_form", "~> 0.3"
gem "nilify_blanks", "~> 1.4"
gem "nokogiri", "~> 1.13" # XML handling
gem "omniauth", "~> 2.1"
gem "omniauth-facebook", "~> 9.0"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "paper_trail", "~> 12.3"
gem "paperclip", "~> 6.1"
gem "rails", "~> 7.0.4"
gem "rails-controller-testing", "~> 1.0"
gem "RedCloth", "~> 4.3"
gem "rgeo", "~> 2.4"
gem "rgeo-geojson", "~> 2.1"
gem "sass-rails", "~> 6.0" # SCSS compiling
gem "select2-rails", "~> 4.0"
gem "sprockets-rails", "~> 3.4"
gem "to_xls", "~> 1.5"
gem "turnout", "~> 2.5"
gem "uuidtools", "~> 2.2"
gem "webpacker", "~> 5.4"
gem 'whenever', "~> 1.0", require: false

group :test, :development do
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
end

group :production, :staging do
  gem "execjs", "~> 2.8"
  gem "terser", "~> 1.1"
end

group :test do
  gem "database_cleaner", "~> 2.0"
  gem "guard-rspec", "~> 4.7"
  gem "launchy", "~> 2.5"
end

group :development do
  gem "annotate", "~> 3.2"
  gem "better_errors", "~> 2.9"
  gem "bcrypt_pbkdf", "~> 1.1", require: false
  gem "binding_of_caller", "~> 1.0"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-db-tasks", "~> 0.6", :require => false
  gem 'capistrano-nvm', "~> 0.0.7", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-yarn", "~> 2.0", require: false
  gem "ed25519", "~> 1.3", require: false
  gem "lorem-ipsum", "~> 0.1"
  gem "thin", "~> 1.8"
end
