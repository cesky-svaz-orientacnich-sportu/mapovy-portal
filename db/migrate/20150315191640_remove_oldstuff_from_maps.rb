class RemoveOldstuffFromMaps < ActiveRecord::Migration
  def change
    remove_column :maps, :draft, :boolean
    remove_column :maps, :removed, :boolean
    remove_column :maps, :layer_index, :integer
  end
end
