class AddPublicClubs < ActiveRecord::Migration[6.1]
  def up
    add_column :clubs, :is_public, :boolean, default: false
    Club::PUBLIC_CLUBS.each do |abbr, patron|
      c = Club.where(:abbreviation => abbr).first || Club.create(:abbreviation => abbr)
      c.update_attribute(:name, patron["name"])
      if patron.key?("region")
        c.update_attribute(:region, Map::REGIONS[patron["region"]].sub(/kraj/i, "").strip)
      end
      c.update_attribute(:is_public, true)
      puts "#{abbr} -> #{patron["name"]}"
    end
  end

  def down
    Club.where(:is_public => true).each{|p| p.destroy}
    remove_column :clubs, :is_public, :boolean, default: false
  end
end
