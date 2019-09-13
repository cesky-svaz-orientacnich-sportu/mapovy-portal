class AddShapeGeomToMap < ActiveRecord::Migration
  def up
  	add_column :maps, :shape_geom, :geometry, { null: true }
  	
  	Map.where('shape_json IS NOT NULL').update_all('shape_geom = ST_FlipCoordinates(ST_Force2D(ST_GeomFromGeoJSON(concat(\'{"type":"Polygon","coordinates":[\', shape_json, \']}\'))))');
  end

  def down
  	remove_column :maps, :shape_geom, :geometry
  end
end
