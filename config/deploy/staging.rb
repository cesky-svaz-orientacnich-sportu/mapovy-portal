# -*- encoding : utf-8 -*-
set :deploy_to, '/home/mapserver/mapserver.staging'
server 'siven.onesim.net', :app, :web, :db, :primary => true
set :rails_env, 'staging'
