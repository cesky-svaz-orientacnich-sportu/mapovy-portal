# -*- encoding : utf-8 -*-
class AddMappingStateToMap < ActiveRecord::Migration
  def change
    add_column :maps, :mapping_state, :string
  end
end
