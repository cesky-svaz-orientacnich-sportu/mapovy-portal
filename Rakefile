#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'ci/reporter/rake/rspec'

Mapserver::Application.load_tasks

task :test => :spec do
end

task :spec => 'ci:setup:rspec'
