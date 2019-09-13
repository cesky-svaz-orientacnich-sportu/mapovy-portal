class AddMapColorColumns < ActiveRecord::Migration
  def up
  	add_column :maps, :color, :string, { limit: 255, null: true }
  	add_column :maps, :stroke_color, :string, { limit: 255, null: true }
  	
  	Map.all.each do |map|
  		map.save
  		puts "#{map.title} colors added"
  	end
  end

  def down
  	remove_column :maps, :color, :string
  	remove_column :maps, :stroke_color, :string
  end
end
