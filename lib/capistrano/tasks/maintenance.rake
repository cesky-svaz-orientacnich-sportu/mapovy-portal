namespace :maintenance do
  desc "Shut down the app for maintenance"
  task :shutdown do
  	on roles :all do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bunde, 'exec', 'rake', 'maintenance:start', "reason=\"#{ENV['reason']}\""
        end
      end
    end
  end

  desc "Restore the app after maintenance"
  task :resume do
    on roles :all do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bunde, 'exec', 'rake', 'maintenance:end'
        end
      end
    end
  end
end
