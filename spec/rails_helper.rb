# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending!

RSpec.configure do |config|

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
  
  # devise
  config.include Devise::TestHelpers, type: :controller  
  config.include Warden::Test::Helpers, type: :feature
  
  config.before(:each, type: :request) do
    default_url_options[:locale] = I18n.default_locale
  end
  
  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
  end
  config.before(:each, type: :feature) do
    Warden.test_mode!
  end
  config.after(:each, type: :feature) do
    Warden.test_reset!
  end


  config.before(:each) do
    User.any_instance.stub(:check_against_oris).and_return(nil)
    Map.any_instance.stub(:fusion_update).and_return(nil)
    Map.any_instance.stub(:save_to_fusion).and_return(nil)
  end

  
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
 
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
 
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
 
  config.before(:each) do
    DatabaseCleaner.start
  end
 
  config.after(:each) do
    DatabaseCleaner.clean
  end
  
end

def as_user(user)
  ui_login(user)
  yield
  ui_logout
end

def ui_login(user)
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  submit_form 'new_user'
end

def ui_logout
  visit destroy_user_session_path
end

def login(user)
  post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
end

def submit_form(id)
  Capybara::RackTest::Form.new(page.driver, page.find_by_id(id).native).submit :name => nil
end

Capybara.javascript_driver = :webkit
