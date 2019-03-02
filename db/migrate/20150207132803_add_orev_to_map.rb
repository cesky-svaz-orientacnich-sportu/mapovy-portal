class AddOrevToMap < ActiveRecord::Migration
  def change
    add_column :maps, :oris_event_id, :integer
  end
end
