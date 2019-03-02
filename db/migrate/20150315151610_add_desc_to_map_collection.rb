class AddDescToMapCollection < ActiveRecord::Migration
  def change
    add_column :map_collections, :description, :text
  end
end
