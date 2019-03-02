class RemoveNameFromMapCollection < ActiveRecord::Migration
  def change
    remove_column :map_collections, :name, :string
  end
end
