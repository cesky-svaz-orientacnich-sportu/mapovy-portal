# -*- encoding : utf-8 -*-
class AddCoordsToMap < ActiveRecord::Migration
  def change
    add_column :maps, :shape_json, :text
    add_column :maps, :shape_kml, :text
  end
end
