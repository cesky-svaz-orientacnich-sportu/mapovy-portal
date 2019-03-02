class AddSlugToMapCollection < ActiveRecord::Migration
  def change
    add_column :map_collections, :slug, :string
    add_index :map_collections, :slug, unique: true
  end
end
