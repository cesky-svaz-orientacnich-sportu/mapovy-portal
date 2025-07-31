source "http://rubygems.org"

ruby "3.3.9"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1" # PostgreSQL as the database for Active Record
gem "activerecord-postgis-adapter", "~> 11.0" # PosgGis extension for PostgreSQL
gem "puma", "~> 6.6"
gem "autoprefixer-rails", "~> 10.4" # vendor prefixin CSS
gem "bootsnap", "~> 1.7"
gem "bootstrap-sass", "~> 3.4"
gem "ci_reporter_rspec", "~> 1.0"
gem "coffee-rails", "~> 5.0"
gem "color", "~> 2.1"
gem "dalli", "~> 3.2"
gem "devise", "~> 4.8"
gem "dotenv", "~> 3.0" # env vars management
gem "exception_notification", "~> 5.0" # get email notifications on exceptions
gem "friendly_id", "~> 5.4"
gem "haml", "~> 6.0"
gem "jquery-datatables-rails", "~> 3.4"
gem "jquery-fileupload-rails", "~> 1.0"
gem "jquery-rails", "~> 4.5"
gem "jquery-ui-rails", "~> 8.0"
gem "kaminari", "~> 1.2"
gem "kaminari-bootstrap", "~> 3.0"
gem "magic_encoding", "~> 0.0.2"
gem "nested_form", "~> 0.3"
gem "nilify_blanks", "~> 1.4"
gem "nokogiri", "~> 1.13" # XML handling
gem "omniauth", "~> 2.1"
gem "omniauth-facebook", "~> 10.0"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "paper_trail", "~> 16.0" # history of changes to records in database
gem "kt-paperclip", "~> 7.2"
gem "rails-controller-testing", "~> 1.0"
gem "RedCloth", "~> 4.3"
gem "rgeo", "~> 3.0"
gem "rgeo-geojson", "~> 2.1"
gem "sass-rails", "~> 6.0" # SCSS compiling
gem "select2-rails", "~> 4.0"
gem "sprockets-rails", "~> 3.4"
gem "to_xls", "~> 1.5"
gem "uuidtools", "~> 3.0"
gem "whenever", "~> 1.0", require: false
gem "array_enum", "~> 1.5"
gem "rack-cors" # CORS handling

group :test, :development do
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails", "~> 6.2"
end

group :production, :staging do
  gem "execjs", "~> 2.8"
  gem "terser", "~> 1.1"
end

group :test do
  gem "database_cleaner", "~> 2.0"
  gem "guard-rspec", "~> 4.7"
  gem "launchy", "~> 3.1" # FIXME: is it even required?
end

group :development do
  gem "better_errors", "~> 2.9"
  gem "bcrypt_pbkdf", "~> 1.1", require: false
  gem "binding_of_caller", "~> 1.0"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-db-tasks", "~> 0.6", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "ed25519", "~> 1.3", require: false
  gem "lorem-ipsum", "~> 0.1"
  gem "thin", "~> 2.0"
  gem "annotaterb", "~> 4.17" # model files annotation comments
end
