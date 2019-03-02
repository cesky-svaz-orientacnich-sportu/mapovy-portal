class RemoveFidFromMaps < ActiveRecord::Migration
  def change
    remove_column :maps, :fusion_id, :integer
  end
end
