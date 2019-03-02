# -*- encoding : utf-8 -*-
class CreateMapCollectionMemberships < ActiveRecord::Migration
  def change
    create_table :map_collection_memberships do |t|
      t.integer :map_id
      t.integer :map_collection_id
      t.integer :year
      t.string :note

      t.timestamps
    end
  end
end
