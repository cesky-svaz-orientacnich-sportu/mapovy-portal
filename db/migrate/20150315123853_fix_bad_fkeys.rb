class FixBadFkeys < ActiveRecord::Migration
  def up
    eval(IO.read("#{Rails.root}/db/migrate/mapping.rb"))
    
    puts "OLD IDS = #{@id2f.keys.uniq.sort}"
    puts "NEW IDS = #{@id2f.values.uniq.sort}"

    cid = Cartographer.group(:map_id).pluck(:map_id).sort
    mid = MapCollectionMembership.group(:map_id).pluck(:map_id).sort
    
    puts "CTG IDS = #{cid}"
    puts "MCM IDS = #{mid}"

    puts
     
    puts "!!! CTG IDS = #{cid - @id2f.keys}"
    puts "!!! MCM IDS = #{mid - @id2f.keys}"

    gid, bid = 0, 0
    Cartographer.find_each do |x|
      map_id = x.map_id
      f_id = @id2f[map_id]
      if f_id
        gid += 1
      else
        bid += 1
      end
    end

    puts "Found #{gid} good and #{bid} bad"
    
    
    Cartographer.find_each do |x|
      map_id = x.map_id
      f_id = @id2f[map_id]
      if f_id
        x.update_attribute :map_id, f_id
      else
        x.destroy
      end
    end
    MapCollectionMembership.find_each do |x|
      map_id = x.map_id
      f_id = @id2f[map_id]
      if f_id
        x.update_attribute :map_id, f_id
      else
        puts x.inspect
      end
    end
  end
end
