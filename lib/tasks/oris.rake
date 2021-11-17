namespace :oris do
  task :users => :environment do
    User.find_each do |u|
      u.check_against_oris
      u.save
    end
  end
  task :clubs => :environment do
    puts "Before build: #{Club.count}"
    Club.build
    puts "After build: #{Club.count} clubs"
  end
  task :obpostupy => :environment do
    #OrisEvent.obpostupy_lookup
  end
  task :events => :environment do
    OrisEvent.fetch(Date.today.year, true)
    OrisEvent.fetch(Date.today.year+1, true)
  end
  task :events_history => :environment do
    (2013..Date.today.year+1).each do |y|
      OrisEvent.fetch(y, true)
    end
  end
  task :events_all => :environment do
    OrisEvent.fetch(Date.today.year, false)
    OrisEvent.fetch(Date.today.year+1, false)
  end
end
