class AddMapEmbargoColumns < ActiveRecord::Migration
  def up
  	add_column :maps, :has_embargo, :boolean, { default: false, null: false }
  	add_column :maps, :embargo_until, :date
  	
  	Map.all.each do |map|
  		map.save
  		puts "#{map.title} embargo updated"
  	end
  end

  def down
  	remove_column :maps, :has_embargo, :string
  	remove_column :maps, :embargo_until, :string
  end
end
