# -*- encoding : utf-8 -*-
require 'capistrano'
require "bundler/capistrano"
require 'capistrano/mysqldump'
load 'deploy/assets'

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'
ssh_options[:forward_agent] = true
ssh_options[:verify_host_key] = :never

set :stages, %w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'

set :mysqldump_bin, "/usr/bin/mysqldump"

set :repository,  "git@github.com:moskyt/mapovy-portal-csos.git"
set :scm, "git"
set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache

set :user, "mapserver"
set :application, "mapserver"
set :keep_releases, 2
set :use_sudo, false

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :kwikfix do
    run "cd #{current_path}; git reset --hard; git pull origin master"
  end

  task :link_data do
    run "cd #{current_path}/public; ln -sf /home/mapserver/data ./data"
  end
end

task :download_system do
  download "#{shared_path}/system", "./public/", :recursive => true, :via => :scp
end

task :pull do
end

before "pull", "mysqldump", "download_system"

namespace :cache do
  task :flush do
    #run "cd #{current_path}; bundle exec rake cache:flush RAILS_ENV=production; bundle exec rake cache:preload RAILS_ENV=production"
  end
end

after "deploy:update_code", "bundle:install", "deploy:migrate", "deploy:cleanup"
after "deploy:update", "deploy:link_data"

after "deploy:kwikfix", "deploy:restart"
after "deploy:restart", "cache:flush"

namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -l #{user} #{hostname} -t 'source ~/.profile && #{current_path}/script/rails c #{rails_env}'"
  end
  task :log, :roles => :app do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -l #{user} #{hostname} -t 'tail -n 500 #{current_path}/log/#{rails_env}.log'"
  end
end

namespace :maintenance do
  desc "Shut down the app for maintenance"
  task :shutdown do
    run "cd #{current_path}; bundle exec rake maintenance:start RAILS_ENV=#{rails_env} reason=\"#{ENV['reason']}\""
  end
  task :resume do
    run "cd #{current_path}; bundle exec rake maintenance:end RAILS_ENV=#{rails_env}"
  end
end