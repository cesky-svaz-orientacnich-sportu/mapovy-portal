# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/rails
#   https://github.com/koenpunt/capistrano-nvm
#   https://github.com/j-arnaiz/capistrano-yarn
#   https://github.com/sgruhier/capistrano-db-tasks
#   https://github.com/javan/whenever
#
require "capistrano/rbenv"
require "capistrano/rails"
require 'capistrano/nvm'
require "capistrano/yarn"
require 'capistrano-db-tasks'
require "whenever/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
