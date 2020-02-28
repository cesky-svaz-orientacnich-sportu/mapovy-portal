class AddCompetitionAreaAndNonOrisEventUrlToMap < ActiveRecord::Migration
  def up
  	add_column :maps, :has_competition_area, :boolean, { default: false, null: false }
  	add_column :maps, :competition_area_until, :date
  	add_column :maps, :non_oris_event_url, :string, { limit: 255, null: true }

  	Map.all.each do |map|
  		map.save
  		puts "#{map.title} - competition area data added"
  	end
  end

  def down
  	remove_column :maps, :has_competition_area, :boolean
  	remove_column :maps, :competition_area_until, :date
  	remove_column :maps, :non_oris_event_url, :string
  end
end
