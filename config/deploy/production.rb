set :stage, :production

server "5.180.201.132",
	user: "mapserver",
	roles: %w{app db web}

set :branch, "rails-upgrade"
set :deploy_to, "/var/www/mapserver"
set :rails_env, "production"
