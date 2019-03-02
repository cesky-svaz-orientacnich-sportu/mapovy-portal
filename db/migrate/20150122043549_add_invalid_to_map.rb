# -*- encoding : utf-8 -*-
class AddInvalidToMap < ActiveRecord::Migration
  def change
    add_column :maps, :removed, :boolean, default: false, null: false
  end
end
