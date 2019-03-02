# -*- encoding : utf-8 -*-
class AddJsondataToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :oris_data_json, :text
  end
end
