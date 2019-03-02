namespace :maps do
  task :embargo => :environment do
    Map.load_embargo(Date.today.year)
    Map.load_embargo(Date.today.year+1)
  end
  task :save_to_fusion => :environment do
    Map.find_each do |m|
      print "."; $stdout.flush
      unless m.fusion_table_record
        puts "Map #{m} has no fusion table record!"
        m.save_to_fusion
        m = Map.find(m.id)
        puts "Now #{m} => #{m.fusion_table_record}"
      end
    end
  end
end