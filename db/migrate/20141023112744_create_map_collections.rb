# -*- encoding : utf-8 -*-
class CreateMapCollections < ActiveRecord::Migration
  def change
    create_table :map_collections do |t|
      t.string :name
      t.string :title

      t.timestamps
    end
  end
end
