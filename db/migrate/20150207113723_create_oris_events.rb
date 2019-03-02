# -*- encoding : utf-8 -*-
class CreateOrisEvents < ActiveRecord::Migration
  def change
    create_table :oris_events do |t|
      t.integer :oris_id
      t.date :date
      t.string :title
      t.text :oris_json, limit: 20000000
      t.string :place
      t.datetime :oris_timestamp

      t.timestamps
    end
  end
end
