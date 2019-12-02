namespace :maps do
  task :embargo => :environment do
    Map.load_embargo(Date.today.year)
    Map.load_embargo(Date.today.year+1)
  end
end