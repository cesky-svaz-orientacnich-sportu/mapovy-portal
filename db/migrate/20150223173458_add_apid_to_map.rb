# -*- encoding : utf-8 -*-
class AddApidToMap < ActiveRecord::Migration
  def change
    add_column :maps, :approved_by_id, :integer
  end
end
