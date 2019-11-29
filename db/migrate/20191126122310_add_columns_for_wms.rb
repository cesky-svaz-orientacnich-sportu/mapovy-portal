class AddColumnsForWms < ActiveRecord::Migration
  def up
  	add_column :maps, :shape_geom, :geometry, { null: true }
    add_column :maps, :cartographers_for_api, :string, { limit: 255, null: true }
  	add_column :maps, :color, :string, { limit: 255, null: true }
  	add_column :maps, :stroke_color, :string, { limit: 255, null: true }
  	add_column :maps, :has_embargo, :boolean, { default: false, null: false }
  	add_column :maps, :embargo_until, :date
  	add_column :maps, :has_blocking, :boolean, { default: false, null: false }
  	add_column :maps, :blocking_from, :integer
  	add_column :maps, :blocking_until, :integer
  	
  	Map.all.each do |map|
  		map.save
  		puts "#{map.title} - data for WMS added"
  	end
  end

  def down
  	remove_column :maps, :shape_geom, :geometry
    remove_column :maps, :cartographers_for_api, :string
  	remove_column :maps, :color, :string
  	remove_column :maps, :stroke_color, :string
  	remove_column :maps, :has_embargo, :boolean
  	remove_column :maps, :embargo_until, :date
  	remove_column :maps, :has_blocking, :boolean
  	remove_column :maps, :blocking_from, :integer
  	remove_column :maps, :blocking_until, :integer
  end
end
