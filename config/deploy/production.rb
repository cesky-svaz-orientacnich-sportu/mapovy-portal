set :stage, :production

server "5.180.201.132",
	user: "mapserver",
	roles: %w{app db web cron}

set :branch, "master"
set :deploy_to, "/var/www/mapserver"
set :rails_env, "production"
