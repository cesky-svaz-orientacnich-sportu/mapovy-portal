# -*- encoding : utf-8 -*-
set :stage, :production
set :deploy_to, '/home/mapserver/mapserver'
server 'goldfish.amagical.net', :app, :web, :db, :primary => true
set :rails_env, 'production'
