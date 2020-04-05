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
end

after "deploy:updating", "bundler:install", "deploy:migrate", "deploy:cleanup"
after "deploy:symlink:release", "deploy:link_data"
