class AddAttachmentLogoToMapCollections < ActiveRecord::Migration
  def self.up
    change_table :map_collections do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :map_collections, :logo
  end
end
