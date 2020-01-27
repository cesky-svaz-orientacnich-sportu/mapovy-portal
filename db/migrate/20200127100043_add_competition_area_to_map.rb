class AddCompetitionAreaToMap < ActiveRecord::Migration
  def up
  	add_column :maps, :has_competition_area, :boolean, { default: false, null: false }
  	add_column :maps, :competition_area_until, :date
  	
  	Map.all.each do |map|
  		map.save
  		puts "#{map.title} - competition area data added"
  	end
  end

  def down
  	remove_column :maps, :has_competition_area, :boolean
  	remove_column :maps, :competition_area_until, :date
  end
end
