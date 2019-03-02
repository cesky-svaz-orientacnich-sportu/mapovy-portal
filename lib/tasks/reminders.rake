namespace :reminders do
  task :check => :environment do
    puts "PROPOSED"
    Map.where(state: Map::STATE_PROPOSED).each do |map|
      if map.reminder__on_proposed
        puts map.to_label
        puts " - state change #{(Date.today-map.state_changed_at).to_i} days ago"
        puts " - last reminder at #{map.last_reminder_sent_at} days ago"
      end
    end
    puts "NOT COMPLETED"
    Map.where(state: Map::STATE_APPROVED).each do |map|
      if map.reminder__before_completed?
        puts map.to_label
        puts " - race was #{(Date.today-map.race_date).to_i} days ago"
        puts " - last reminder at #{map.last_reminder_sent_at} days ago"
      end
    end
    puts "REQUEST FOR CHANGE"
    Map.where(state: [Map::STATE_CHANGE_REQUESTED, Map::STATE_FINAL_CHANGE_REQUESTED]).each do |map|
      if map.reminder__on_requested_change?
        puts map.to_label
        puts " - state change #{(Date.today-map.state_changed_at).to_i} days ago"
        puts " - last reminder at #{map.last_reminder_sent_at} days ago"
      end
    end
  end
  
  task :send => :environment do
    Map.where(state: Map::STATE_PROPOSED).each do |map|
      if map.reminder__on_proposed
        MapStateMailer.reminder_on_proposed(map).deliver
      end
    end
    Map.where(state: Map::STATE_APPROVED).each do |map|
      if map.reminder__before_completed?
        MapStateMailer.reminder_before_completed(map).deliver
      end
    end
    Map.where(state: [Map::STATE_CHANGE_REQUESTED, Map::STATE_FINAL_CHANGE_REQUESTED]).each do |map|
      if map.reminder__on_requested_change?
        MapStateMailer.reminder_on_requested_change(map).deliver
      end
    end
  end
end


