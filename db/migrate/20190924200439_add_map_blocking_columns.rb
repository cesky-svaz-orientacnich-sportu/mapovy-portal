class AddMapBlockingColumns < ActiveRecord::Migration
  def up
  	add_column :maps, :has_blocking, :boolean, { default: false, null: false }
  	add_column :maps, :blocking_from, :integer
  	add_column :maps, :blocking_until, :integer
  	
  	Map.all.each do |map|
  		map.save
  		puts "#{map.title} blocking updated"
  	end
  end

  def down
  	remove_column :maps, :has_blocking, :boolean
  	remove_column :maps, :blocking_from, :integer
  	remove_column :maps, :blocking_until, :integer
  end
end
