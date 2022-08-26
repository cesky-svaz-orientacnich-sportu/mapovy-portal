namespace :deploy do
  desc "Restart Application"
  task :restart do
    on roles :app do
      within current_path do
        execute :touch, 'tmp/restart.txt'
      end
    end
  end

  desc "Point `public/data` to `data` in home directory"
  task :link_data do
  	on roles :all do
      within current_path do
        case fetch(:stage)
        when :production
          execute :ln, '-sf', '/home/mapserver/data', 'public/data'
        when :staging
          execute :ln, '-sf', '/home/mapserver_staging/data', 'public/data'
        end
      end
    end
  end

  desc "Generate JS localization files"
  task :locale_js do
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec', 'rake', 'locale_js'
        end
      end
    end
  end
end

before "deploy:updated", "deploy:locale_js"
after "deploy:symlink:release", "deploy:link_data"
after 'deploy:published', 'deploy:restart'
