# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "mapserver"
set :repo_url, "git@github.com:cesky-svaz-orientacnich-sportu/mapovy-portal.git"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2

set :ssh_options, verify_host_key: :never
set :ssh_options, forward_agent: true
set :scm_verbose, true

# Set correct rbenv path
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} /usr/bin/rbenv exec"

# Set NodeJS version
set :nvm_node, 'v16.16.0'

# Rails

# You'll probably want to symlink Rails shared files and directories.
append :linked_files, '.env', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# While migrations looks like a concern of the database layer, Rails migrations are strictly related to the framework.
set :migration_role, :app

# DB tasks

# Remove the local dump file after loading.
set :db_local_clean, true

# Remove the dump file from the server after downloading.
set :db_remote_clean, true

# Whenever crontab integration
set :whenever_roles, ->{ :cron }
