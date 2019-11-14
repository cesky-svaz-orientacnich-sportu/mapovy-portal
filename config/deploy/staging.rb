# -*- encoding : utf-8 -*-
set :stage, :staging
set :deploy_to, '/home/mapserver/mapserver_staging'
server 'goldfish.amagical.net', :app, :web, :db, :primary => true
set :rails_env, 'staging'
