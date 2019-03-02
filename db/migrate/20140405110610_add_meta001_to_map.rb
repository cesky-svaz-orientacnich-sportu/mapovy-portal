# -*- encoding : utf-8 -*-
class AddMeta001ToMap < ActiveRecord::Migration
  def change
    add_column :maps, :created_by_id, :integer
    add_column :maps, :draft, :boolean, null: false, default: false
  end
end
